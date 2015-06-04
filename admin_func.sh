#!/usr/bin/env bash

# Fonction détaillant l'utilisation de la commande users
function users_usage {
  echo -e "Utilisations possibles: \n-a [nomUser]\n-d [nomUser]\n-p [nomUser]\n+r [nomUser] [machine] \n-r [nomUser] [machine]\n-l\n-lp"
}

# Fonction d'ajout d'utilisateur
function users_add {
  # On test si l'utilisateur existe
    if  ! grep -q $1 admin/passwd ; then
      echo -e "$1\nMot de passe : "
      read -sr passwd
      md_pass=$(echo $passwd | md5sum | sed "s/^\(.*\) -/\1/" )

      echo $1 >> admin/list ; echo $1 $md_pass >> admin/passwd
      touch users/$1
      a_afinger -e $1 # On renseigne les informations
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
      rm users/$1
    else
      echo "$1 n'existe pas dans la base."
    fi
}

# Fonction de modification de mot de passe
function users_change_pass {
  if  grep -q $1 admin/passwd ; then
    sed -i "/$1/d" admin/passwd
    echo -e "$1\nNouveau mot de passe : "
    read -sr passwd
    md_pass=$(echo -n $passwd | md5sum | sed "s/^\(.*\) -/\1/"  )

    echo $1 $md_pass >> admin/passwd
  else
    echo "$1 n'existe pas dans la base."
  fi
}

# Fonction d'ajout de droit
function users_add_right {

  if grep -q $1 admin/list ; then

    #if grep -q "$2$" machines/list ; then
    if [[ -r machines/$2 ]]; then
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
    #if grep -q "$2$" machines/list ; then
    if [[ -r machines/$2 ]]; then
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
    if [[ ! -f machines/$1 ]]; then
      touch machines/$1
      echo "La machine $1 vient d'etre ajoutee."
    else
      echo "$1 existe deja dans la base."
    fi
}

# Fonction de suppression de machine
function vm_del {
  # On teste si la machine existe
    if [[ -f machines/$1 ]]; then
      rm machines/$1

      echo "Suppression des permissions sur $1."
      sed -i "s/$1//g" admin/list # Suppression des permissions sur $1.

      echo "La machine $1 vient d'etre supprimee."
    else
      echo "$1 n'existe pas dans la base."
    fi
}

# Fonction détaillant l'utilisation de la commande afinger
function afinger_usage {
  echo -e "Utilisations possibles: \n-e [nomUser]\n-l [nomUser] "
}

# Fonction permettant l'édition des infos utilisateur
function afinger_edit {
  # On test si l'utilisateur existe
    if   grep -q $1 admin/list ; then
      echo "Nom :" ; read -r nom
      echo "Email :" ; read -r email
      echo -e "Login : $1\nName : $nom\nEmail : $email\nSessions actives :" > users/$1
    else
      echo "$1 n'existe pas dans la base."
    fi
}

# Fonction permettant d'afficher des infos utilisateur
function afinger_show {
  # On test si l'utilisateur existe
    if   grep -q $1 admin/list ; then
      cat users/$1
    else
      echo "$1 n'existe pas dans la base."
    fi
}

# Fonction de gestion de la commande users
function a_users {
  case $1 in
    -a ) users_add $2 ;;
    -d ) users_del $2 ;;
    -p ) users_change_pass $2 ;;
    +r ) users_add_right $2 $3 ;;
    -r ) users_del_right $2 $3 ;;
    -l ) cat admin/list | cut -f1 -d ' ' ;;
    -lp ) cat admin/list ;;
    * )  users_usage ;;
  esac
}

# Fonction de gestion de la commande host
function a_host {
  case $1 in
    -a ) vm_add $2 ;;
    -d ) vm_del $2 ;;
    -l ) for i in machines/* ; do echo -e "$(basename $i)" ; done ;;
    * ) host_usage ;;
  esac
}

# Fonction de gestion de la commande afinger
function a_afinger {
  case $1 in
    -e ) afinger_edit $2 ;;
    -l ) afinger_show $2 ;;
    * ) afinger_usage ;;
  esac
}
