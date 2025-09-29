#!/bin/bash
echo "Début du script"

# Cloner le dépôt GitHub
WORK_DIR="/home/onyxia/work"
DOWNLOAD_URL="https://raw.githubusercontent.com/InseeFrLab/methodes_ensemblistes_notebooks/refs/heads/main/Python/classification_binaire_rf.ipynb"
echo $DOWNLOAD_URL
curl -L $DOWNLOAD_URL -o "${WORK_DIR}/classification_binaire_rf.ipynb"

# Lancer Jupyter Notebook
echo "Ouverture du notebook..."
echo "c.LabApp.default_url = '/lab/tree/classification_binaire_rf.ipynb'" >> /home/onyxia/.jupyter/jupyter_server_config.py


echo "Fin du script"
