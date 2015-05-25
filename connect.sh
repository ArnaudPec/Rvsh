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

printLogo

loop
