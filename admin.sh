#!/usr/bin/env bash

# Inclusion des fonctions de la partie administrateur
source func_admin.sh


# Fonction définnissant la boucle du prompt admin
P1="rvsh>"

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

# Fonction de gestion de la commande users

function users {
  case $1 in
    -a )
        user_add $2
      ;;
    -d )
        user_del $2
      ;;
    -p )
        user_change_pass $2
      ;;
    +r )
        user_add_right $2 $3
      ;;
    -r )
        user_del_right $2 $3
      ;;
    -l )
      cat admin/list | cut -f1 -d ' '
      ;;
    * )
      user_usage
      ;;


  esac
}

# Lancement du prompt
loop
