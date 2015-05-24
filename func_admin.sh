#!/usr/bin/env bash

# Fonction détaillant l'utilisation de la commande users
function users_usage {
  echo -e "Utilisations possibles: \n-a [nomUser]\n-d [nomUser]\n-p [nomUser]\n+r [nomUser] [machine] \n-r [nomUser] [machine]\n-l\-lp"
}

# Fonction d'ajout d'utilisateur
function users_add {
  # On test si l'utilisateur existe
    if  ! grep -q $1 admin/passwd ; then
      echo -e "$1\nMot de passe : "
      read -sr var
      echo $1 >> admin/list ; echo $1 $var >> admin/passwd
    else
      echo "$1 existe deja dans la base."
    fi


}

# Fonction de suppression d'utilisateur
function users_del {
  # On test si l'utilisateur existe
    if   grep -q $1 admin/list ; then
      sed -i "/$1/d" admin/list
      sed -i "/$1/d" admin/passwd
    else
      echo "$1 n'existe pas dans la base."
    fi


}

# Fonction de modification de mot de passe
function users_change_pass {

  if  grep -q $1 admin/passwd ; then
    sed -i "/$1/d" admin/passwd
    echo -e "$1\nNouveau mot de passe : "
    read -sr var
    echo $1 $var >> admin/passwd
  else
    echo "$1 n'existe pas dans la base."
  fi

}

# Fonction d'ajout de droit
function users_add_right {

  if grep -q $1 admin/list ; then

    if grep -q "$2$" machines/list ; then
      if grep  -q "^$1 .*$2" admin/list ; then
        echo  "$1 est deja autorise sur $2."
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

# Fonction de suppression de droit
function users_del_right {

  if grep -q $1 admin/list ; then

    if grep -q "$2$" machines/list ; then
      if grep -q  "^$1 .*$2" admin/list; then
        echo "Suppression de l'autorisation de $1 sur $2."
        grep $1 admin/list | sed "s/$2//" >> admin/list # On supprime la machine de la ligne de l'utilisateur et on réecrit cette ligne en fin de fichier
        sed -i "0,/$1/{/$1/d}" admin/list # On supprime la première ligne de permission de l'utilisateur
      else
        echo  "$1 n'est pas autorise sur $2."
      fi
    else
      echo "$2 n'existe pas sur le réseau"
    fi
  else
    echo "$1 n'existe pas dans la base."
  fi
}

# Fonction détaillant l'utilisation de la commande host
function host_usage {
  echo -e "Utilisations possibles: \n-a [machine]\n-d [machine]\n-l"
}

# Fonction d'ajout de machine
function vm_add {
  # On teste si la machine existe
    if  ! grep -q $1 machines/list ; then
      echo $1 >> machines/list ; touch machines/$1
      echo "La machine $1 vient d'etre ajoutee."
    else
      echo "$1 existe deja dans la base."
    fi


}

# Fonction de suppression de machine
function vm_del {
  # On teste si la machine existe
    if   grep -q $1 machines/list ; then
      sed -i "/$1/d" machines/list
      rm machines/$1

      echo "Suppression des permissions sur $1."
      sed -i "s/$1//g" admin/list # Suppression des permissions sur $1.

      echo "La machine $1 vient d'etre supprimee."
    else
      echo "$1 n'existe pas dans la base."
    fi


}
