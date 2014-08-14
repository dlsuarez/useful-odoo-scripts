#!/bin/bash

##
# USER VARIABLES, FEEL FREE TO CHANGE THEM
# -----------------------------------------------------------------------------
# Path to the folder that contains the OCA directory
OCA_PARENT_PATH=$(pwd)
# Path to the foldet that will contain symbolic links
ADDONS_PATH='all_addons'

##
# CREATE DIRECTORIES, AND CHANGE PATHS
# -----------------------------------------------------------------------------
# Save the current path to restore it when script ends
CURRENT_PATH=$(pwd)

# Create and empty the addons directory
mkdir -p $ADDONS_PATH
rm -R $ADDONS_PATH/*

# Change current path to the OCA parent folder
cd $OCA_PARENT_PATH

##
# CREATE SYMBOLIC LINKS
# @param string $1 Absolute path to the real folder
# @param string $2 Relative path to the symbolic link
# @param string $3 Name of the addon
# -----------------------------------------------------------------------------
function createSymbLink() {
  local REAL=$1
  local SYMLINK=$2
  local NAME=$3
  local YELLOW='\e[1;33m'
  local NC='\e[0m' # No Color

  if [ -e $SYMLINK ]; 
    then
      echo -e "${YELLOW}No se crea el duplicado $NAME${NC}";
    else
      echo "Enlazando $NAME"
      ln -s $REAL $SYMLINK
  fi
}

##
# CREATE SYMBOLIC LINKS TO OCB/addons DIRECTORIES
# -----------------------------------------------------------------------------
OCB=$(ls -l OCA/OCB/addons/ | grep ^d | grep -v unported | tr -s ' ' ' ' | \
  cut -f 9 -d ' ' | sort )
  
for variable in $OCB;
do
  REAL="$OCA_PARENT_PATH/OCA/OCB/addons/$variable"
  SYMLINK="$ADDONS_PATH/$variable"

  createSymbLink $REAL $SYMLINK $variable
done

##
# CREATE SYMBOLIC LINKS TO ODDER PROJECT DIRECTORIES IF NOT EXIST YET
# -----------------------------------------------------------------------------
NOOCB=$(find -maxdepth 3 -mindepth 3 -type d | grep -v '\./OCA/OCB' | \
  grep -v '\.git$' | grep -v unported | cut -b 7- | sort)
  
for variable in $NOOCB;
do
  ADDON=$(echo $variable | cut -f 2 -d '/')
  REAL="$OCA_PARENT_PATH/OCA/$variable"
  SYMLINK="$ADDONS_PATH/$ADDON"
  
  createSymbLink $REAL $SYMLINK $ADDON
done

##
# RESTORE THE CURRENT PATH
# -----------------------------------------------------------------------------
cd $CURRENT_PATH
