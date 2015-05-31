#!/usr/bin/env bash

# Inclusion des fonctions de la partie connect
source connect_func.sh

# Fonction définnissant la boucle du prompt


function loop {
  P1="$1@$2>"
  printLogo

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


}

# Fonction de gestion de la commande rhost

function rhost {
  if [[ $# -eq 0 ]]; then
    rhost_print
  else
    rhost_usage
  fi
}

# Fonction permettant de quitter la boucle courante, c'est à dire deconnecter l'utilisateur courant; si
# c'est l'utilisateur du lancement du script, cela permet de quitter le programme
function exit {
  break
}
