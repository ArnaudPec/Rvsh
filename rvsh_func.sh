#!/usr/bin/env bash

function usage {
  echo -e "Erreur: mauvaise syntaxe.\nMode connect : rvsh -connect  [nomMachine] [nomUser]\nMode admin : rvsh -admin"
}

function  checkInit {
  return $(test -e admin/admin)
}

function init {
  mkdir -p admin users machines && echo $1 >> admin/admin
  touch admin/{list,passwd} machines/list
}



function checkPassAdmin {
  read -r < admin/admin var
  if [[ ! $var == $1 ]]; then
    echo "Mot de passe faux"
    exit 0
  else
      clear # && printLogo
  fi
}

# Tester l'existence de la machine sur laquelle on tente de se connecter
function checkMachine {
  return $(test -e machines/$1)
}

# Tester l'existence de l'utilisateur qui tente de se connecter
function  checkUser {
  return $(test -e users/$1)
}

# Vérifier si le mot de passe est juste
function checkPassUser {
  return $(test $2 == $(grep $1 admin/passwd | sed -e "s/^$1 //") )
}

# Tester si l'utilisateur a bien le droit de se connecter sur la machine
function checkRight {
  return $(grep  -q "^$1 .*$2" admin/list)
}

# Fonction regroupant les 4 tests qui précèdent une connexion : existence de la machine,
# existence de l'utilisateur, vérification des autorisations et du mot de passe
function connect {
  checkMachine $1
  if [[ $? -eq 0 ]]; then
    checkUser $2
    if [[ $? -eq 0 ]]; then
      checkRight $2 $1
      if [[ $? -eq 0 ]]; then
        checkPassUser $2 $3
        if [[ $? -eq 0 ]]; then
          return 0
        else
          echo "Mot de passe faux"
          return 1
        fi

        else
        echo "L'utilisateur $2 n'est pas autorisé sur $1."
        return 1
      fi

    else
      echo "L'utilisateur $2 n'existe pas dans la base."
      return 1
    fi
  else
    echo "La machine $1 n'existe pas sur le reseau."
    return 1
  fi

}
