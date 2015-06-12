# Fichier regroupant les fonctions usage associées à chaque commande

#!/usr/bin/env bash

# Fonction d'usage du script
function usage {
  echo -e "Erreur: mauvaise syntaxe.\nMode connect : rvsh -connect  [nomMachine] [nomUser]\nMode admin : rvsh -admin"
}

# Fonction détaillant l'utilisation de la commande host
function host_usage {
  echo -e "[host] Utilisations possibles: \n-a [machine]\n-d [machine]\n-l"
}

# Fonction détaillant l'utilisation de la commande su
function su_usage {
  echo -e "[su] Utilisations possibles: \nsu [nameUser]"
}

# Fonction détaillant l'utilisation de la commande rhost
function rhost_usage {
  echo -e "[rhost] Utilisations possible: \nrhost"
}

# Fonction détaillant l'utilisation de la commande finger
function finger_usage {
  echo -e "[finger] Utilisations possible: \nfinger"
}

# Fonction détaillant l'utilisation de la commande who
function who_usage {
  echo -e "[who] Utilisations possible: \nwho"
}

# Fonction détaillant l'utilisation de la commande rusers
function rusers_usage {
  echo -e "[rusers] Utilisations possible: \nrusers"
}

# Fonction détaillant l'utilisation de la commande passwd
function passwd_usage {
  echo -e "[passwd] Utilisation possible: \npasswd"
}
# Fonction détaillant l'utilisation de la commande write
function write_usage {
  echo -e "[write] Utilisation possible: \nwrite [nomUser]@[machine] [message]"
}

# Fonction détaillant l'utilisation de la commande afinger
function afinger_usage {
  echo -e "[afinger] Utilisations possibles: \n-e [nomUser]\n-l [nomUser] "
}

# Fonction détaillant l'utilisation de la commande users
function users_usage {
  echo -e "[users] Utilisations possibles: \n-a [nomUser]\n-d [nomUser]\n-p [nomUser]\n+r [nomUser] [machine] \n-r [nomUser] [machine]\n-l\n-lp"
}

# Fonction détaillant l'utilisation de la commande users
function connect_usage {
  echo -e "[connect] Utilisation possible: \nconnect [machine] [nomUser]"
}

# Fonction détaillant l'utilisation de la commande backup
function backup_usage {
  echo -e "[backup] Utilisation possible: \nbackup\nbackup -l\nbackup -d [nomBackup]"
}

# Fonction détaillant l'utilisation de la commande restore
function restore_usage {
  echo -e "[backup] Utilisation possible: \nrestore [nomBackup]"
}
