#!/usr/bin/env bash

function usage {
  echo "Erreur: mauvaise syntaxe"
  echo "Mode connect : rvsh -connect  [nomMachine] [nomUser]"
  echo "Mode admin : rvsh -admin [nomAdmin]"

}

function  checkAdmin {
  if [[ -e admin/admin ]]; then
    exists=1
  else
    exists=0
  fi

}

function init {
  mkdir -p admin users machines && echo $1 >> admin/admin
  touch admin/{list,passwd} machines/list
}


#function checkPassUser{
#  read -r < admin/list var
#  if [[ ! $var == $1 ]]; then
#    echo "Mot de passe faux"
#    exit 0
#  else
#    echo "acces autorisé"
#  fi

#}

function printLogo {

echo '
 /$$$$$$$  /$$    /$$  /$$$$$$  /$$   /$$
| $$__  $$| $$   | $$ /$$__  $$| $$  | $$
| $$  \ $$| $$   | $$| $$  \__/| $$  | $$
| $$$$$$$/|  $$ / $$/|  $$$$$$ | $$$$$$$$
| $$__  $$ \  $$ $$/  \____  $$| $$__  $$
| $$  \ $$  \  $$$/   /$$  \ $$| $$  | $$
| $$  | $$   \  $/   |  $$$$$$/| $$  | $$
|__/  |__/    \_/     \______/ |__/  |__/
'

}


function checkPassAdmin {
  read -r < admin/admin var
  if [[ ! $var == $1 ]]; then
    echo "Mot de passe faux"
    exit 0
  else
      clear && printLogo
  fi

}
