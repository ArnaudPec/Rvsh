#!/usr/bin/env bash

# Fonction d'ajout d'utilisateur
function users_add {
  # On test si l'utilisateur existe
    if  ! grep -q $1 admin/passwd ; then
      echo -en "[$1] Mot de passe : "
      read -sr passwd
      md_pass=$(echo -n $passwd | md5sum | sed "s/^\(.*\) -/\1/" )
      echo $1 >> admin/list ; echo $1 $md_pass >> admin/passwd
      touch users/$1
      echo -e "" ; a_afinger -e $1 # On renseigne les informations
    else
      echo "$1 existe deja dans la base."
    fi
}

# Fonction de suppression d'utilisateur
function users_del {
  # On test si l'utilisateur existe
    if   grep -q $1 admin/passwd ; then
      if  ! sed "1,/Session/d" users/$1 | grep -q . ; then
        sed -i "/$1/d" admin/list
        sed -i "/$1/d" admin/passwd
        rm users/$1
      else
        echo "$1 connecte sur le reseau : suppression impossible".
      fi
    else
      echo "$1 n'existe pas dans la base."
    fi
}

# Fonction qui vérifie si l'utilisateur a le droit de changer son mot de passe : il connaît l'ancien
function users_ask_change_pass {
  if  grep -q $1 admin/passwd ; then

    echo -en "[$1] Ancien mot de passe : "
    read -sr passwd; echo " "
    md_pass=$(echo -n $passwd | md5sum | sed "s/^\(.*\) -/\1/"  )
    checkPassUser $1 $md_pass

    if [[ $? -eq 0 ]]; then
      users_change_pass $1
    else
    echo "Mot de passe faux"
    fi
else
  echo "$1 n'existe pas dans la base."
fi

}

# Fonction de modification de mot de passe
function users_change_pass {
  if  grep -q $1 admin/passwd ; then

      sed -i "/$1/d" admin/passwd
      echo -en "[$1] Nouveau mot de passe : "
      read -sr passwd; echo " "
      md_pass=$(echo -n $passwd | md5sum | sed "s/^\(.*\) -/\1/"  )
      echo $1 $md_pass >> admin/passwd

  else
    echo "$1 n'existe pas dans la base."
  fi
}

# Fonction d'ajout de droit
function users_add_right {

if [[ -n $1 ]]; then

  if grep -q $1 admin/list; then

      if [ -r machines/$2 ] && [ $# -ge 2 ]; then
        if grep  -q "^$1 .*$2" admin/list ; then
          echo  "$1 est deja autorise sur $2."
        else
          echo "Autorisation de $1 sur $2."
          sed -i "s/\($1\)/\1 $2/" admin/list
        fi
      elif [[ -z $2 ]]; then
        echo "Veuillez entrer un nom de machine."
      else
        echo "$2 n'existe pas sur le réseau"
      fi
  else
    echo "$1 n'existe pas dans la base."
  fi
else
  echo "Veuillez entrer un nom d'utilisateur."
fi

}

# Fonction de suppression de droit
function users_del_right {

if [[ -n $1 ]]; then
  if grep -q $1 admin/list ; then
    if [ -r machines/$2 ] && [ $# -ge 2 ]; then
      if grep -q  "^$1 .*$2" admin/list; then
        echo "Suppression de l'autorisation de $1 sur $2."
        grep $1 admin/list | sed "s/$2//" >> admin/list # On supprime la machine de la ligne de l'utilisateur et on réecrit cette ligne en fin de fichier
        sed -i "0,/$1/{/$1/d}" admin/list # On supprime la première ligne de permission de l'utilisateur
      else
        echo  "$1 n'est pas autorise sur $2."
      fi
    elif [[ -z $2 ]]; then
      echo "Veuillez entrer un nom de machine."
    else
      echo "$2 n'existe pas sur le réseau"
    fi
  else
    echo "$1 n'existe pas dans la base."
  fi
else
  echo "Veuillez entrer un nom d'utilisateur."
fi
}



# Fonction d'ajout de machine
function vm_add {
  # On teste si la machine existe
    if [ ! -f machines/$1 ] && [ $# -eq 1 ]; then
      touch machines/$1
      echo "La machine $1 vient d'etre ajoutee."
    elif [[ -z $1 ]]; then
      echo "Veuillez entrer un nom de machine!"
    else
      echo "$1 existe deja dans la base."
    fi

}

# Fonction de suppression de machine
function vm_del {
  # On teste si la machine existe
    if [[ -f machines/$1 ]]; then
      if [[ -s machines/$1 ]]; then
        echo "Utilisateur(s) connecte(s) sur $1 : suppression impossible."
      else
        rm machines/$1

        echo "Suppression des permissions sur $1."
        sed -i "s/$1//g" admin/list # Suppression des permissions sur $1.
        echo "La machine $1 vient d'etre supprimee."
      fi
    else
      echo "$1 n'existe pas dans la base."
    fi
}


# Fonction permettant l'édition des infos utilisateur
function afinger_edit {
  # On test si l'utilisateur existe
    if   grep -q $1 admin/list ; then
      echo -n "Nom :" ; read -r nom

      regex="^(([-a-zA-Z0-9\!#\$%\&\'*+/=?^_\`{\|}~])+\.)*[-a-zA-Z0-9\!#\$%\&\'*+/=?^_\`{\|}~]+@\w((-|\w)*\w)*\.(\w((-|\w)*\w)*\.)*\w{2,4}$"
      email=" "; while [[ ! $email =~ $regex ]]; do
        echo -n "Email :" ; read -r email
      done
      echo -e "Login : $1\nName : $nom\nEmail : $email\nSessions actives :" > users/$1
    else
      echo "$1 n'existe pas dans la base."
    fi
}

# Fonction permettant d'afficher des infos utilisateur
function afinger_show {
  # On teste si l'utilisateur existe
    if   grep -q $1 admin/list ; then
      tput setaf 4
      cat users/$1
      tput setaf 7
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

# Fonction qui vérifie si le système est prêt pour une opération de maintenance (clean, backup, restore)
# c'est à dire aucun user connecté
function checkReadyForMaintenance {
  if ! u_rusers | grep -q . ; then
    echo -e "\nAucun utilisateur connecte : systeme disponible pour maintenance."
    return 0
  else
    echo -e "\nUtilisateur(s) connecte(s) : operation impossible."
    return 1
  fi
}

 # Nettoyage complet du système
function a_clean {

  echo -n "Saisir le mot de passe admin : " ; read -sr passwd
  md_pass=$(echo -n $passwd | md5sum | sed "s/^\(.*\) -/\1/" )
  checkPassUser admin $md_pass
  if [[ $? -eq 0 ]]; then
    checkReadyForMaintenance
    if [[ $? -eq 0 ]]; then
      bash clean_project.sh $1
      exit 0
    fi

  else
    echo "Mot de passe faux."
  fi

}

# Fonction de gestion de la commande backup
function a_backup {
  if [[ $# -eq 0 ]]; then
    backup
  elif [[ $# -eq 1 ]] && [[ $1 == -l ]]; then
    for i in backup/* ; do echo -e "$(basename $i)"; done
  elif [[ $# -eq 2 ]] && [[ $1 == -d ]]; then
    if [[ -e backup/$2 ]]; then  rm backup/$2
    else echo "$2 inexistant."
    fi
  else
    backup_usage
  fi
}

# Sauvegarde complète du système
function backup {

 echo -n "Saisir le mot de passe admin : " ; read -sr passwd
 md_pass=$(echo -n $passwd | md5sum | sed "s/^\(.*\) -/\1/" )
 checkPassUser admin $md_pass
 if [[ $? -eq 0 ]]; then
   checkReadyForMaintenance
   if [[ $? -eq 0 ]]; then
     mkdir -p backup
     fname=backup_`date +%m%d_%U%M_%S`
     tar -cf backup/$fname.tar users/ machines/ admin/ #>> /dev/null
     echo -e "Etat sauvegarde : $fname.tar"
   fi
 else
   echo "Mot de passe faux."
 fi
}

# Gestion de la restoration du système
function a_restore {
if [[ $# -eq 1 ]]; then
  echo -n "Saisir le mot de passe admin : " ; read -sr passwd
  md_pass=$(echo -n $passwd | md5sum | sed "s/^\(.*\) -/\1/" )
  checkPassUser admin $md_pass
  if [[ $? -eq 0 ]]; then
    checkReadyForMaintenance

    if [[ $? -eq 0 ]]; then
      if [[ -e backup/$1 ]]; then
        bash clean_project.sh
        tar -xf backup/$1
        echo -e "Etat chargé : $1"
        #Par mesure de sécurité on change le mot de passe asdmin
        users_change_pass admin

      else echo "$1 inexistant."
      fi
    fi
  else
    echo "Mot de passe faux."
  fi
else
  restore_usage
fi

}

# Fonction permettant de  diffuser une alerte à tous les utilisateurs connectés au système
function  a_alert {

  if [[ $# -gt 0 ]]; then
    while [[ $# -gt 0 ]]
    do
      message="$message $1" # Construction du message
      shift
    done

    for i in machines/*; do # Envoi du message sur tous les tty
        while read line; do
          echo "Alerte : $message" >> $( echo $line | cut -f2 -d " " )
        done < $i
    done
  else
    alert_usage
  fi

}
