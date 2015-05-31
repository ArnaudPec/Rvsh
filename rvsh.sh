#!/usr/bin/env bash

# @(#) Auteurs : Walid Sadaoui, Arnaud Pecoraro
# @(#) Date : 2015

# Inclusion des fonctions de connexions
source rvsh_func.sh
source admin.sh
source connect.sh

  if [[ $1 == "-connect" && $# -eq 3 ]]; then

    connect $2 $3

  elif [[ $1 == "-admin" && $# -eq 1 ]]; then
    clear
    checkInit
    if [[ $? -eq 0 ]]; then

      echo "Saisir le mot de passe admin"
      read  -sr passwd
      checkPassAdmin $passwd

     bash admin.sh

    else

      echo -e "Creation du compte admin.\nVeuillez entrer un mot de passe : "
      read  -sr passwd
      init $passwd

     bash admin.sh

    fi

  else
    usage
  fi
