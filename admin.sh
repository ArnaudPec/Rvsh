#!/usr/bin/env bash

source func_admin.sh

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

function users {
  case $1 in
    -a )
        user_add $2 
      ;;
    -d )
        user_add $2 $3
      ;;
    -p )
        user_add $2 $3
      ;;
    +r )
    user_add $2 $3
      ;;
    -r )
    user_add $2 $3
      ;;
    * )
      user_usage
      ;;


  esac
}

loop
