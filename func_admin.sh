#!/usr/bin/env bash

function user_usage {
  echo -e "Utilisations possibles: \n-a [nomUser] [passwd]\n-d [nomUser]\n-p  [nomUser] [passwd]\n+r [nomUser] [machine] \n-r [nomUser] [machine]"
}

function user_add {
  # On test si l'utilisateur existe

  # Si il n'existe pas on peut l'ajouter
  echo -e "$1\nMot de passe : "
  read -sr var
  echo $1 >> admin/list ; echo $1 $var >> admin/passwd
}
