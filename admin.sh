#!/usr/bin/env bash

# Inclusion des fonctions de la partie administrateur
source admin_func.sh

# Inclusion des fonctions de la partie connect
source connect_func.sh

# Fonction définnissant la boucle du prompt admin
P1="rvsh>"

function loop_admin {
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
        users_add $2
      ;;
    -d )
        users_del $2
      ;;
    -p )
        users_change_pass $2
      ;;
    +r )
        users_add_right $2 $3
      ;;
    -r )
        users_del_right $2 $3
      ;;
    -l ) #liste
      cat admin/list | cut -f1 -d ' '
      ;;
    -lp ) #liste avec permissions
      cat admin/list
      ;;
    * )
      users_usage
      ;;
  esac
}

# Fonction de gestion de la commande host

function host {
  case $1 in
    -a )
        vm_add $2
      ;;
    -d )
        vm_del $2
      ;;
    -l )
        cat machines/list
      ;;
    * )
      host_usage
      ;;
  esac
}

# Fonction de gestion de la commande afinger

function afinger {
  case $1 in
    -e )
      afinger_edit $2
      ;;
    -l )
      afinger_show $2
      ;;
    * )
      afinger_usage
      ;;
  esac
}

#printLogo
# Lancement du prompt
#loop_admin
