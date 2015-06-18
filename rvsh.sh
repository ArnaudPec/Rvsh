#!/usr/bin/env bash

# @(#) Auteurs : Walid Sadaoui, Arnaud Pecoraro
# @(#) Date : 2015

source usages.sh # Inclusion des fonctions usages
source rvsh_func.sh # Inclusion des fonctions de lancement du script
source admin_func.sh # Inclusion des fonctions du mode admin
source connect_func.sh # Inclusion des fonctions du mode connect

if [[ $1 == "-connect" && $# -eq 3 ]]; then
  checkInit
  if [[ $? -eq 0 ]]; then
    u_connect $2 $3
  else
    echo -e "Le systeme n'est pas initialise.\nVeuillez lancer rvsh -admin."
  fi

elif [[ $1 == "-admin" && $# -eq 1 ]]; then
  checkInit
  if [[ $? -eq 0 ]]; then

    echo -n "Saisir le mot de passe admin : " ; read -sr passwd
    md_pass=$(echo -n $passwd | md5sum | sed "s/^\(.*\) -/\1/" )

    checkPassUser admin $md_pass
    if [[ $? -eq 0 ]]; then
      loop  "admin"
    else
      echo "Mot de passe faux."
      exit 0
    fi
  else
    echo -en "Creation du compte admin.\nVeuillez entrer un mot de passe : "
    read  -sr passwd
    md_pass=$(echo -n $passwd | md5sum | sed "s/^\(.*\) -/\1/" )
    init $md_pass
    loop "admin"
  fi
else
    usage
fi
