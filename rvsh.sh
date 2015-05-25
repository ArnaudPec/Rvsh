#!/usr/bin/env bash

# @(#) Auteurs : Walid Sadaoui, Arnaud Pecoraro
# @(#) Date : 2015

# Inclusion des fonctions de connexions
source rvsh_func.sh

  if [[ $1 == "-connect" && $# -eq 3 ]]; then

    checkInit
    if [[ $? -eq 0 ]]; then
      clear

      echo "$3 : Saisir le mot de passe"
      read  -sr passwd
      connect $2 $3 $passwd

      if [[ $? -eq 0 ]]; then
        bash connect.sh $3 $2
      else
        exit 0
      fi

    else

      echo -e "Le systeme n'est pas initialise.\nVeuillez lancer rvsh -admin."

    fi

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
