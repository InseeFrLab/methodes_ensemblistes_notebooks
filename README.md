# Notebook sur document méthodologique sur les méthodes ensemblistes

## Description
Ce notebook accompagne le document méthodologique de l'Insee "Les méthodes ensemblistes appliquées à la statistique publique". Il vise à faciliter la prise en main de ces méthodes en les illustrants sur quelques cas d'usage fréquemment rencontrés dans la statistique publique.

## Gestion des dépendances
Ce projet utilise `renv` pour gérer les dépendances.

## Structure du Projet
Voici la structure principale du projet :

- methodes_ensemblistes_notebooks/

  - R/
    - setup_project.R       # Script de gestion des packages et de l'environnement renv: à exécuter au lancement du projet
    - import_data.R         # Script pour importer les données
    - regression_rf.R       # Script présentant une régression par random forest
    - classification_rf.R   # Script présentant une classification par random forest
    
  - data/
    - raw/                   # Données brutes
    - processed/             # Données transformées
    
  - documentation/           # Documentation et références
  
  - renv.lock                # Fichier incluant les packages vérouillés de l'environnement 
  
  - .Rprofile                # Inclut `renv::activate()` pour activer `renv` automatiquement
                             # Défini une variable d'environnement pour l'endpoint S3
                             
                             
# Description détaillée des dossiers et fichiers                           
                             
                             
                             