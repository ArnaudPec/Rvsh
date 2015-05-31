#!/usr/bin/env bash

# Fonction d'affichage du logo
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

# Fonction d'écriture des logs de connexions
function add_log_user {
  sed -i "/^$/d" users/$1 machines/$2
  echo -e "$2 $(tty) $(date "+%a %d %b %Y %H:%M:%S")" >> users/$1
  echo -e "$1 $(tty) $(date "+%a %d %b %Y %H:%M:%S")" >> machines/$2
}

# Fonction de suppression des logs à la déconnexion
function del_log_user {
  #echo $3
  t=$(echo $3 | sed 's@/@\\/@g')
  #echo $t
  sed -i "/$2 $t/d" users/$1
  sed -i "/$1 $t/d" machines/$2
}

# Fonction de gestion des connexions
function u_connect {
    clear
    echo "$2 : Saisir le mot de passe"
    read  -sr passwd
    checkConnect $1 $2 $passwd

    if [[ $? -eq 0 ]]; then
      add_log_user $2 $1
      loop  $2 $1
    fi
}

# Fonction détaillant l'utilisation de la commande rhost
function rhost_usage {
  echo -e "Utilisations possible: \nrhost"
}

function rhost_print {
  echo -e "Machines presentes sur le reseau :\n=================================="
  #cat machines/list
  for i in machines/* ; do echo -e "$(basename $i)" ; done
  echo "=================================="
}

# Fonction définissant la boucle du prompt
function loop {
  clear ;printLogo

  while true :
  do

    if [[ $1 == "admin" ]]; then  P1="rvsh>"
    else P1="$1@$2>"
    fi

    echo -n "$P1"
    read commande args

    if [ "$(type -t "a_$commande")" = "function" ]; then
      if [[ $1 == "admin" ]]; then
        a_$commande $args
      else
        echo "Non autorise."
      fi
    elif [[ "$(type -t "u_$commande")" = "function"  ]]; then
      u_$commande $args
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


# Fonction détaillant l'utilisation de la commande finger
function finger_usage {
  echo -e "Utilisations possible: \nfinger"
}
# Fonction de gestion de la commande finger
function u_finger {
  if [[ $# -eq 0 ]]; then
    a_afinger -l $(echo $P1 | cut -f1 -d "@")
  else
    finger_usage
  fi
}

# Fonction détaillant l'utilisation de la commande who
function who_usage {
  echo -e "Utilisations possible: \nwho"
}
# Fonction de gestion de la commande who
function u_who {
  if [[ $# -eq 0 ]]; then
    cat machines/$(echo $P1 | cut -f2 -d "@" | cut -f1 -d ">")
  else
    who_usage
  fi
}

# Fonction détaillant l'utilisation de la commande rusers
function rusers_usage {
  echo -e "Utilisations possible: \nrusers"
}
# Fonction de gestion de la commande rusers
function u_rusers {
  if [[ $# -eq 0 ]]; then
    for i in machines/*; do
      if [[ -s $i ]]; then
        echo -e "$(basename $i) :\n" ; cat $i ; echo -e "\n"
      fi
    done
  else
    rusers_usage
  fi
}

# Fonction détaillant l'utilisation de la commande rusers
function rusers_usage {
  echo -e "Utilisation possible: \nrusers"
}
# Fonction de gestion de la commande rusers
function u_rusers {
  if [[ $# -eq 0 ]]; then
    for i in machines/*; do
      if [[ -s $i ]]; then
        echo -e "$(basename $i) :\n" ; cat $i ; echo -e "\n"
      fi
    done
  else
    rusers_usage
  fi
}


# Fonction détaillant l'utilisation de la commande passwd
function passwd_usage {
  echo -e "Utilisation possible: \npasswd"
}
# Fonction de gestion de la commande passwd
function u_passwd {
  if [[ $# -eq 0 ]]; then
    users_change_pass  $(echo $P1 | cut -f1 -d "@")
  else
    passwd_usage
  fi
}

function checkUserConnected {
  return $(grep -q $1 machines/$2)
}

# Fonction détaillant l'utilisation de la commande write
function write_usage {
  echo -e "Utilisation possible: \nwrite [nomUser]@[machine] [message]"
}
# Fonction de gestion de la commande write
function u_write {
  if [[ $# -eq 2 ]]; then
    #on vérifie si l'utilisateur donné est bien connecté sur la machine donnée
    u=$(echo $1 | cut -f1 -d "@")
    m=$(echo $1 | cut -f2 -d "@")
    checkUserConnected $u $m
    if [[ $? -eq 0 ]]; then
      echo "$u connecte sur $m"
      echo "Message de $P1 : $2" >> $(grep -m 1 "$u" machines/$m | cut -f2 -d " ") 
    else
      echo "$u non connecte sur $m"
    fi
  else
    write_usage
  fi
}

# Fonction permettant de quitter la boucle courante, c'est à dire deconnecter l'utilisateur courant; si
# c'est l'utilisateur du lancement du script, cela permet de quitter le programme
function u_quitter {
  echo $P1
  u=$(echo $P1 | cut -f1 -d "@")
  m=$(echo $P1 | cut -f2 -d "@" | cut -f1 -d ">" )
  echo
  del_log_user $u $m $(tty)
  break
}
