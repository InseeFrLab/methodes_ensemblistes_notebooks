#!/bin/bash
echo "Début du script"

# Cloner le dépôt GitHub
#echo "Clonage du dépôt..."
# rm -rf dt
# git clone https://github.com/InseeFrLab/methodes_ensemblistes_notebooks.git dt || { echo "Échec du clonage"; exit 1; }

# Methode 2
WORK_DIR="/home/onyxia/work"
DOWNLOAD_URL="https://raw.githubusercontent.com/InseeFrLab/methodes_ensemblistes_notebooks/refs/heads/main/Python/classification_binaire_rf.ipynb"
echo $DOWNLOAD_URL
curl -L $DOWNLOAD_URL -o "${WORK_DIR}/classification_binaire_rf.ipynb"


# Naviguer vers le répertoire du notebook
#echo "Accès au répertoire du notebook..."
#cd dt/Python || { echo "Échec de l'accès au répertoire"; exit 1; }

# Lancer Jupyter Notebook
echo "Ouverture du notebook..."
# quarto render classification_binaire_rf.ipynb || { echo "Échec du lancement de Jupyter"; exit 1; }
echo "c.LabApp.default_url = '/lab/tree/classification_binaire_rf.ipynb'" >> /home/onyxia/.jupyter/jupyter_server_config.py



# Download the notebook directly using curl


echo "Fin du script"
