# Notebooks accompagnant le document méthodologique sur les méthodes ensemblistes

## Description
Ce dépôt rassemble les notebooks accompagnant le document méthodologique de l'Insee "Les méthodes ensemblistes appliquées à la statistique publique". Il vise à faciliter la prise en main de ces méthodes en les illustrants sur quelques cas d'usages à partir de données publiques en accès libre.

[![Lancer avec Jupyter](https://img.shields.io/badge/SSPCloud-Lancer%20avec%20Jupyter-blue)](https://datalab.sspcloud.fr/launcher/ide/jupyter-python?name=RF%20classification&version=2.1.17&git.repository=«https%3A%2F%2Fgithub.com%2FInseeFrLab%2Fmethodes_ensemblistes_notebooks.git»&git.branch=«main»&autoLaunch=true)


[![Lancer avec Jupyter](https://img.shields.io/badge/SSPCloud-Lancer%20avec%20Jupyter-blue)](https://datalab.sspcloud.fr/launcher/ide/jupyter-python?name=RF%20Classification&version=2.1.17&init.personalInit=«https%3A%2F%2Fraw.githubusercontent.com%2FInseeFrLab%2Fmethodes_ensemblistes_notebooks%2Fmain%2Finit_script.sh»&git.repository=«https%3A%2F%2Fgithub.com%2FInseeFrLab%2Fmethodes_ensemblistes_notebooks.git»&git.branch=«main»&autoLaunch=true)







[![Lancer avec VSCode](https://img.shields.io/badge/SSPCloud-Lancer%20avec%20VSCode-blue)](https://datalab.sspcloud.fr/launcher/ide/vscode-python?name=RF%20Classification&version=2.1.18&git.repository=«https%3A%2F%2Fgithub.com%2FInseeFrLab%2Fmethodes_ensemblistes_notebooks.git»&git.branch=«main»&autoLaunch=true)

## Gestion des dépendances
Ce projet utilise `renv` pour gérer les dépendances R et `Conda` pour gérer les dépendances Python.

## Structure du Projet
Voici la structure principale du projet :

- methodes_ensemblistes_notebooks/

  - setup_project_Python.sh    # Script a exécuter au lancement du projet: configure l'environnement Python
                                 # Pour exécuter ce script:
                                  # Ouvrir un terminal
                                  # chmod +x setup_project_Python.sh # Donne les droits d'exécution
                                  # source setup_project_Python.sh
                                  
  - setup_project_R.R          # Script a exécuter au lancement du projet: configure l'environnement R

  - R/
    - import_data.R         # Script pour importer les données
    - regression_rf.R       # Script présentant une régression par random forest
    - classification_rf.R   # Script présentant une classification par random forest

  - Python/
    - import_data.ipynb         # Script pour importer les données
    - regression_rf.ipynb       # Script présentant une régression par random forest
    - classification_rf.ipynb   # Script présentant une classification par random forest

  - data/
    - raw/                   # Données brutes
    - processed/             # Données transformées
    
  - documentation/           # Documentation et références
 
  - environment.yml          # Fichier généré par setup.sh. Il fige les versions des packages Python nécessaires au projet.
  - renv.lock                # Fichier généré par setup_project.R. Il fige les versions des packages R nécessaires au projet.
  
  - .Rprofile                # Inclut `renv::activate()` pour activer `renv` automatiquement
                             # Défini une variable d'environnement pour l'endpoint S3
                             
                             
# Description détaillée des dossiers et fichiers                           
                             
                             
                             
