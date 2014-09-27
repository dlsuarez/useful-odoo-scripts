#!/bin/bash

# It is assumed Odoo is installed and runing
# This script is valid only for 7.0 version of Odoo


# REQUIRED VARIABLES
# Feel free to change them!
# ================================================================================
UPDATESOURCES=NO	# YES | NO

MAINIP=$(ifconfig | grep inet: | grep -v 127.0.0.1 | sed -E 's/^[^0-9]+//;s/ .*$//')

PASSPHRASE=123456789012

ODOOPORT=30800
ODOOCONF="/opt/odoo/8.0/config/odoo_$ODOOPORT.conf"
ODOOSRV="odoo_$ODOOPORT"

SSLACCESSLOG="/var/log/nginx/odoo-$ODOOPORT-access.log"
SSLERRORLOG="/var/log/nginx/odoo-$ODOOPORT-error.log"


# NGINX INSTALLATION
# ================================================================================
if [ "$UPDATESOURCES" = "YES" ]
  then
    apt-get update
fi

apt-get install nginx


# MAKING NEEDED CERTIFICATES
# ================================================================================

# Temporal passphrase file with passin and passout passwords respectively
echo $PASSPHRASE > /tmp/secret-$$.tmp
echo $PASSPHRASE >> /tmp/secret-$$.tmp

# Generation of the new key
openssl genrsa -des3 -passout file://tmp/secret-$$.tmp -out server.pkey 2048
openssl rsa -passin file://tmp/secret-$$.tmp -in server.pkey -out server.key

# Removing the passphrase
openssl req -new -passin file://tmp/secret-$$.tmp -passout file://tmp/secret-$$.tmp -key server.key -out server.csr<<EOF
${C}
${ST}
${L}
${O}
${OU}
${CN}
${USER}@${CN}
.
.
EOF

# Self signing certificate
openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt

# Setting file permisions
chown root:www-data server.crt server.key
chmod 640 server.crt server.keypassphrase 

# Moving file to nginx ssl certificates folder
mkdir -p /etc/ssl/nginx/
mv server.crt server.key /etc/ssl/nginx/

# Setting filder permisions
chown www-data:root /etc/ssl/nginx
chmod 710 /etc/ssl/nginx


# CONFIGURING NGINX
# ================================================================================

# Removing default nginx config file
rm /etc/nginx/sites-enabled/default

# Building nginx config file with required policies
cat > /etc/nginx/sites-available/odoo <<EOF
upstream openerpweb {
    server 127.0.0.1:$ODOOPORT weight=1 fail_timeout=300s;
}

server {
    listen 80;
    server_name    $MAINIP;

    # Strict Transport Security
    add_header Strict-Transport-Security max-age=2592000;

    rewrite ^/mobile.*\$ https://$MAINIP/web_mobile/static/src/web_mobile.html permanent;
    rewrite ^/webdav(.*)\$ https://$MAINIP/webdav/\$1 permanent;
    #rewrite ^/.*\$ https://$MAINIP/web/webclient/home permanent;
    rewrite ^/.*\$ https://$MAINIP permanent;
}

server {
    # server port and name
    listen        443 default;
    server_name   $MAINIP;

    # Specifies the maximum accepted body size of a client request, 
    # as indicated by the request header Content-Length. 
    client_max_body_size 200m;

    # ssl log files
    access_log    $SSLACCESSLOG;
    error_log    $SSLERRORLOG;

    # ssl certificate files
    ssl on;
    ssl_certificate        /etc/ssl/nginx/server.crt;
    ssl_certificate_key    /etc/ssl/nginx/server.key;

    # add ssl specific settings
    keepalive_timeout    60;

    # limit ciphers
    ssl_ciphers            HIGH:!ADH:!MD5;
    ssl_protocols            SSLv3 TLSv1;
    ssl_prefer_server_ciphers    on;

    # increase proxy buffer to handle some OpenERP web requests
    proxy_buffers 16 64k;
    proxy_buffer_size 128k;

    location / {
        # es la direccion del servidor originalnic08alq10mg sin SSL
        proxy_pass    http://localhost:$ODOOPORT;  # http://openerpweb;
        # force timeouts if the backend dies
        proxy_next_upstream error timeout invalid_header http_500 http_502 http_503;

        # set headers
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;# RESTARTING SERVICES
# ================================================================================
        proxy_set_header X-Forward-For \$proxy_add_x_forwarded_for;

        # Let the OpenERP web service know that we're using HTTPS, otherwise
        # it will generate URL using http:// and not https://
        proxy_set_header X-Forwarded-Proto https;

        # by default, do not forward anything
        proxy_redirect off;
    }

    # cache some static data in memory for 60mins.
    # under heavy load this should relieve stress on the OpenERP web interface a bit.
    location ~* /web/static/ {
        proxy_cache_valid 200 60m;
        proxy_buffering    on;
        expires 864000;
        proxy_pass http://localhost:$ODOOPORT;  # http://openerpweb;
    }
}

EOF

# Adding symbolic link to config file in sites-enabled nginx folder
ln -s /etc/nginx/sites-available/odoo /etc/nginx/sites-enabled/odoo


# CONFIGURING ODOO
# ================================================================================

# Changing Odoo configuration to leasning only on localhost
sed 's/xmlrpc_interface = .*$/xmlrpc_interface = 127.0.0.1/g' $ODOOCONF
sed 's/netrpc_interface = .*$/netrpc_interface = 127.0.0.1/g' $ODOOCONF


# RESTARTING SERVICES
# ================================================================================

# Restarting services
service $ODOOSRV restart
service nginx restart


# REMOVING TEMPORARY FILES
# ================================================================================

# Removing temporal passphrase file
rm /tmp/secret-$$.tmp