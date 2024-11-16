# Notebook sur document méthodologique sur les méthodes ensemblistes

## Description
Ce notebook accompagne le document méthodologique de l'Insee "Les méthodes ensemblistes appliquées à la statistique publique". Il vise à faciliter la prise en main de ces méthodes en les illustrants sur quelques cas d'usages à partir de données publiques en accès libre.

## Gestion des dépendances
Ce projet utilise `renv` pour gérer les dépendances R et `Conda` pour gérer les dépendances Python.

## Structure du Projet
Voici la structure principale du projet :

- methodes_ensemblistes_notebooks/

  - setup_project_Python.sh    # Script a exécuter au lancement du projet: configure l'environnement Python
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
 
  - environment.yml          # Fichier généré par setup.sh. Il inclut les packages Python utiles.
  - renv.lock                # Fichier généré par setup_project.R. Il fige les versions des packages R nécessaires au projet.
  
  - .Rprofile                # Inclut `renv::activate()` pour activer `renv` automatiquement
                             # Défini une variable d'environnement pour l'endpoint S3
                             
                             
# Description détaillée des dossiers et fichiers                           
                             
                             
                             