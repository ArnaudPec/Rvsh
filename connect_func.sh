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


function connect {
  checkInit
  if [[ $? -eq 0 ]]; then
    clear

    echo "$2 : Saisir le mot de passe"
    read  -sr passwd
    checkConnect $1 $2 $passwd

    if [[ $? -eq 0 ]]; then
      loop  $2 $1
    else
      exit 0
    fi

  else

    echo -e "Le systeme n'est pas initialise.\nVeuillez lancer rvsh -admin."

  fi
}

# Fonction détaillant l'utilisation de la commande rhost
function rhost_usage {
  echo -e "Utilisations possible: \nrhost"
}

function rhost_print {
  echo -e "Machines presentes sur le reseau :\n=================================="
  cat machines/list
  echo "=================================="
}
