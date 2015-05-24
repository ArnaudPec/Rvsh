#!/usr/bin/env bash

# @(#) Auteurs : Walid Sadaoui, Arnaud Pecoraro
# @(#) Date : 2015

# Inclusion des fonctions de connexions

source rvsh_func.sh

  if [[ $1 == "-connect" && $# -eq 3 ]]; then
    clear
    echo "$3 : Saisir le mot de passe"
    read  -sr passwd
  elif [[ $1 == "-admin" && $# -eq 1 ]]; then
    checkAdmin
    clear
    if [[ $exists == "1" ]]; then

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
