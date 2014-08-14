# Script create symbolic links to all OCA addons

This script was written in bash code. It creates, in some folder, symbolic links to all the OCA addons.

## Notes

Acronyms

* **OCA**: Odoo Community Association
* **OCB**: Odoo Community Backports

URLs to download repos

* https://api.github.com/orgs/OCA/repos
* https://api.github.com/users/OCA/repos

## Issues found

* ``ls -l`` returns lines with different number os spaces, this problem 
can be solved redirecting out to ``tr -s ' ' ' ' `` with a pipe.

## How use it

1. Set ``OCA_PARENT_PATH=`` var to the folder that contains the **OCA** 
folder cloned from [Github](https://github.com/OCA).
1. Set ``ADDONS_PATH=`` var to the folder that will contain created 
symbolic links.