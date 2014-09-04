#!/bin/bash

REPOS=()
REPOSFILENAME=repos_$$.json
BRANCH=5.0

# Make sure only root can run our script
function checkIfRoot () {
  if [ "$(id -u)" != "0" ]; 
    then
    echo "This script must be run as root" 1>&2
    exit 1
  fi
}

function removeJSON() {
  if [ -f /tmp/$REPOSFILENAME ] ;
    then
    rm /tmp/$REPOSFILENAME
  fi
}

function getJSON() {
  wget -O /tmp/$REPOSFILENAME https://api.github.com/orgs/OCA/repos?per_page=10000
}

function findRepos() {
  if [ -f /tmp/$REPOSFILENAME ] ;
    then
    REPOS=$(cat /tmp/$REPOSFILENAME | grep -o 'git://[^"]*')
  fi
}

function downloadRepos() {
  for REPO in $REPOS; 
    do
      echo -n "Getting $REPO"
      git clone -b $BRANCH $REPO > /dev/null 2>&1
      
      if [ $? -ne 0 ];
	then
	  echo -e " => \e[31mFAIL\e[0m"
	else
	  echo -e " => \e[32mOK\e[0m" 
      fi
  done
  
}

checkIfRoot

removeJSON
getJSON
findRepos
downloadRepos

removeJSON

