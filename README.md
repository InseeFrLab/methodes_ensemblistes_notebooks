# Notebooks accompagnant le document méthodologique sur les méthodes ensemblistes

<a href="https://datalab.sspcloud.fr/launcher/ide/vscode-python?name=Notebooks_ensemble&version=2.3.20&s3=region-79669f20&resources.limits.cpu=«30000m»&resources.limits.memory=«83Gi»&git.repository=«https%3A%2F%2Fgithub.com%2Finseefrlab%2Fmethodes_ensemblistes_notebooks.git»&autoLaunch=true" target="_blank" rel="noopener" data-original-href="https://datalab.sspcloud.fr/launcher/ide/vscode-python?name=Notebooks_ensemble&version=2.3.20&s3=region-79669f20&resources.limits.cpu=«30000m»&resources.limits.memory=«83Gi»&git.repository=«https%3A%2F%2Fgithub.com%2Finseefrlab%2Fmethodes_ensemblistes_notebooks.git»&autoLaunch=true"><img src="https://custom-icon-badges.demolab.com/badge/SSP%20Cloud-Launch_with_VSCode-blue?logo=vsc&amp;logoColor=white" alt="Onyxia"></a>

## Description
Ce dépôt rassemble les notebooks accompagnant le document méthodologique de l'Insee "Les méthodes ensemblistes appliquées à la statistique publique". Il vise à faciliter la prise en main de ces méthodes en les illustrants sur quelques cas d'usages à partir de données publiques en accès libre.

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
                             
                             
                             