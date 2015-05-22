#!/usr/bin/env bash

function user_usage {
  echo -e "Utilisations possibles: \n-a [nomUser] [passwd]\n-d [nomUser]\n-p [nomUser] [passwd]\n+r [nomUser] [machine] \n-r [nomUser] [machine]"
}

function user_add {
  # On test si l'utilisateur existe
    if  ! grep -q $1 admin/passwd ; then
      echo -e "$1\nMot de passe : "
      read -sr var
      echo $1 >> admin/list ; echo $1 $var >> admin/passwd
    else
      echo "$1 existe deja dans la base."
    fi


}

function user_del {
  # On test si l'utilisateur existe
    if   grep -q $1 admin/list ; then
      sed -i "/$1/d" admin/list
      sed -i "/$1/d" admin/passwd
    else
      echo "$1 n'existe pas dans la base."
    fi


}

function user_change_pass {

  if  grep -q $1 admin/passwd ; then
    sed -i "/$1/d" admin/passwd
    echo -e "$1\nNouveau mot de passe : "
    read -sr var
    echo $1 $var >> admin/passwd
  else
    echo "$1 n'existe pas dans la base."
  fi

}

function user_add_right {

  if grep -q $1 admin/list ; then

    if grep -q $2 machines/list ; then
      if grep -q "$1 $2" admin/list; then
        echo  "$1 est deja autorise sur $2"
      else
        echo "Autorisation de $1 sur $2."
        sed -i "s/\($1\)/\1 $2/" admin/list

      fi
    else
      echo "$2 n'existe pas sur le réseau"
    fi
  else
    echo "$1 n'existe pas dans la base."
  fi
}

function user_del_right {

  if grep -q $1 admin/list ; then

    if grep -q $2 machines/list ; then
      if grep -q $1 $2 admin/list; then
        echo  "$1 est deja autorise sur $2"
      else
        echo "Autorisation de $1 sur $2."
        sed -i "s/\(^$1\).\(*\)/\1 $2 \2/" admin/list
      fi
    else
      echo "$2 n'existe pas sur le réseau"
    fi
  else
    echo "$1 n'existe pas dans la base."
  fi
}
