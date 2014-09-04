#!/bin/bash

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# dateutil : provides powerful extensions to the standard datetime module, 
# available in Python 2.3+.
apt-get install python-dateutil

# feedparser : universal Feed Parser for Python
apt-get install python-feedparser

# gdata : Google Data Python client library
apt-get install python-gdata

# ldap : LDAP interface module
apt-get install python-ldap

# libxslt1 : Python bindings for XSLT transformation library
apt-get install python-libxslt1

# lxml : lxml is the most feature-rich and easy-to-use library for working 
# with XML and HTML in the Python language.
apt-get install python-lxml

# mako : fast and lightweight templating for the Python platform.
apt-get install python-mako

# openid : OpenID authentication support for servers and consumers
apt-get install python-openid

# psycopg2 : the most popular PostgreSQL adapter for the Python programming 
# language.
apt-get install python-psycopg2

# babel : tools for internationalizing Python applications
apt-get install python-pybabel

# pychart : library for creating high quality Encapsulated Postscript, PDF, 
# PNG, or SVG charts.
apt-get install python-pychart

# pydot : provides a full interface to create, handle, modify and process 
# graphs in Graphviz's dot language.
apt-get install python-pydot

# pyparsing : library for parsing Python code
apt-get install python-pyparsing

# reportlab : The ReportLab Toolkit is the time-proven, ultra-robust, 
# open-source engine for programmatically creating PDF documents and forms the 
# foundation of RML. It also contains a library for creating 
# platform-independent vector graphics. It is a fast, flexible, cross-platform 
# solution written in Python.
apt-get install python-reportlab

# simplejson : simple, fast, extensible JSON encoder/decoder
apt-get install python-simplejson

# vatnumber : module to validate VAT numbers for European countries
apt-get install python-vatnumber

# vobject : VObject simplifies the process of parsing and creating iCalendar 
# and vCard objects.
apt-get install python-vobject

# pytz : World Timezone Definitions for Python
apt-get install python-tz

# webdav : WebDAV server implementation in Python
apt-get install python-webdav

# werkzeug : collection of utilities for WSGI applications
apt-get install python-werkzeug

# yaml : YAML parser and emitter for Python.
apt-get install python-yaml

# xlwt : module for reading/writing Microsoft Excel spreadsheet files
apt-get install python-xlwt

# zsi : Zolera Soap client infrastructure
apt-get install python-zsi
