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
  if [[ $# -eq 3 ]]; then
    t=$(echo $3 | sed 's@/@\\/@g')
    sed -i "/$2 $t/d" users/$1 ; sed -i "/$1 $t/d" machines/$2
  fi
  }

# Fonction de gestion des connexions
function u_connect {
  if [[ $# -eq 2 ]]; then
    clear
    echo -n "[$2] Saisir le mot de passe : "
    read -sr passwd
    echo " "
    md_pass=$(echo -n $passwd | md5sum | sed "s/^\(.*\) -/\1/" )
    checkConnect $1 $2 $md_pass

    if [[ $? -eq 0 ]]; then
      add_log_user $2 $1
      loop  $2 $1
    fi
  else
      connect_usage
  fi
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

# Fonction de gestion de la commande finger
function u_finger {
  if [[ $# -eq 0 ]]; then
    if [[ $P1 == "rvsh>" ]]; then
      echo "Compte Administrateur : console d'administration."
    else
      a_afinger -l $(echo $P1 | cut -f1 -d "@")  | sed '1,/Session/d'
    fi
  else
    finger_usage
  fi
}
#cat ~/LO14_Projet_Linux/users/alice | sed '1,/Session/d' | awk '{ printf "%-10s %s %s %s %s %s\n", $1, $2, $4, $5, $6, $7 }'

# Fonction de gestion de la commande who
function u_who {
  if [[ $# -eq 0 ]]; then
    if [[ $P1 == "rvsh>" ]]; then
      echo "Admin : unique utilisateur de la console d'administration"
    else
      cat machines/$(echo $P1 | cut -f2 -d "@" | cut -f1 -d ">")
    fi
  else
    who_usage
  fi
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

# Fonction de gestion de la commande passwd
function u_passwd {
  if [[ $# -eq 0 ]]; then
    if [[ $P1 == "rvsh>" ]]; then
      users_ask_change_pass admin
    else
      users_ask_change_pass  $(echo $P1 | cut -f1 -d "@")
    fi
  else
    passwd_usage
  fi
}

function checkUserConnected {
  return $(grep -q $1 machines/$2)
}


# Fonction de gestion de la commande write
function u_write {
  if [[ $# -ge 2 ]]; then
    #on vérifie si l'utilisateur donné est bien connecté sur la machine donnée
    u=$(echo $1 | cut -f1 -d "@")
    m=$(echo $1 | cut -f2 -d "@")

    shift
    while [[ $# -gt 0 ]]
    do
      message="$message $1"
      shift
    done

    checkUserConnected $u $m
    if [[ $? -eq 0 ]]; then
      echo "$u connecte sur $m : message envoye."
      echo "Message de $P1 : $message" >> $(grep -m 1 "$u" machines/$m | cut -f2 -d " ")
    else
      echo "$u non connecte sur $m"
    fi
  else
    write_usage
  fi
}

function u_su {

  if [[ $# -eq 1 ]]; then
    if [[ $P1 == "rvsh>" ]]; then
      echo "Les utilisateurs n'ont pas accès à la console d'administration"
    else
      p=${P1#*@}
      u_connect ${p%*>} $1 #connexion
    fi
  else
  su_usage
  fi
}

# Fonction permettant de quitter la boucle courante, c'est à dire deconnecter l'utilisateur courant; si
# c'est l'utilisateur du lancement du script, cela permet de quitter le programme
function u_quitter {
  if [[ $P1 == "rvsh>" ]]; then
    break
  else
    u=$(echo $P1 | cut -f1 -d "@")
    m=$(echo $P1 | cut -f2 -d "@" | cut -f1 -d ">" )
    del_log_user $u $m $(tty)
    break
  fi
}

function u_help {
  if [[ $P1 == "rvsh>" ]]; then
    echo -e "Commandes disponibles :\nconnect\nclear\nsu\nwrite\nfinger\nwho\nrusers\nrhost\nhelp\npasswd \nquitter"
  else
    echo -e "Commandes disponibles :\nconnect\nclear\nsu\nwrite\nfinger\nwho\nrusers\nrhost\nhelp\npasswd \nquitter"
  fi
}

function u_clear {
  clear
}
