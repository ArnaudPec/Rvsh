#!/usr/bin/env bash

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

function u_connect {

    clear

    echo "$2 : Saisir le mot de passe"
    read  -sr passwd
    checkConnect $1 $2 $passwd

    if [[ $? -eq 0 ]]; then
      loop  $2 $1
    fi


}

# Fonction détaillant l'utilisation de la commande rhost
function rhost_usage {
  echo -e "Utilisations possible: \nrhost"
}

function rhost_print {
  echo -e "Machines presentes sur le reseau :\n=================================="
  cat machines/list
  echo "=================================="
}


# Fonction définissant la boucle du prompt

function loop {
  printLogo

  while true :
  do

    if [[ $1 == "admin" ]]; then
      P1="rvsh>"
    else
      P1="$1@$2>"
    fi

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

function u_rhost {
  if [[ $# -eq 0 ]]; then
    rhost_print
  else
    rhost_usage
  fi
}

# Fonction permettant de quitter la boucle courante, c'est à dire deconnecter l'utilisateur courant; si
# c'est l'utilisateur du lancement du script, cela permet de quitter le programme
function u_quitter {
  break
}
