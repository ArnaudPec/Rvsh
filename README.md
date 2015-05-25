# RVSH

Script réalisé dans le cadre de l'uv LO14.
Simule un réseau de machines virtuelles.

## Caractéristiques

- Ajout suppression d'utilisateur et de machines virtuelles
- Gestion des droits d'accès
- Simulation des commandes d'administration de base

## Utilisation

###Mode administrateur
```sh
bash rvsh.sh -admin
```

###Mode Utilisateur
```sh
bash rvsh.sh -connect [nomMachine] [nomUser]
```

## Nettoyage

```sh
bash clean_project.sh
```

2015
