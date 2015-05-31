#!/usr/bin/env bash

# Inclusion des fonctions de la partie connect
source connect_func.sh

# Fonction définnissant la boucle du prompt admin
P1="$1@$2>"

function loop {
  while true :
  do

    echo -n "$P1"
    read commande args

    if [ "$(type -t $commande)" = "function" ]; then
  	    $commande $args
  	else
  	    echo "Commande inexistante"
  	fi

  done;
  exit 0

}

# Fonction de gestion de la commande rhost

function rhost {
  if [[ $# -eq 0 ]]; then
    rhost_print
  else
    rhost_usage
  fi
}

function su {

  if [[ $# -eq 1 ]]; then
    #statements
    #machine= cut -f2 -d '@' P1
    #former_machine=${P1%*@}
    p2=${P1#*@}
    if  grep -q "$1 ${p2%*>}" admin/list   ; then
      P1="$1@${P1#*@}"
    else
      echo "Cet utilisateur n'existe pas"
    fi
  else
    su_usage
  fi
}





printLogo

loop
