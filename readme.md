# Script para descargar Odoo versión OCA

Este script, escrito en Python, descarga todos los paquetes de 
la rama comunitaria de Odoo en su versión más reciente (excepto 
la rama master).

## Notas

Siglas

* OCA: Odoo Community Association
* OCB: Odoo Community Backports

URLs para descarga de JSON

* https://api.github.com/orgs/OCA/repos
* https://api.github.com/users/OCA/repos

Documentación
* https://developer.github.com/v3/
* https://pythonhosted.org/GitPython/
* https://www.python.org/doc/

## Problemas encontrados

 1. Al invocar métodos que crean un subproceso en consola: 
call ó git.execute aparece un error de archivo no encontrado, 
esto se solventa pasando la cadena de órdenes como un array.
Por ejemplo: `mkdir folder`  debería invocarse como 
['mkdir','folder']`

## Contribuir al proyecto
Si tienes un parche, o has tropezado con un problema en el
script, puedes contribuir con ello al código.