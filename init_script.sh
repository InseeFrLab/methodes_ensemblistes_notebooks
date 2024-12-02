#!/bin/bash
set -x

echo "Début du script"

# Cloner le dépôt GitHub
#echo "Clonage du dépôt..."
#git clone https://github.com/InseeFrLab/methodes_ensemblistes_notebooks.git || { echo "Échec du clonage"; exit 1; }

# Naviguer vers le répertoire du notebook
echo "Accès au répertoire du notebook..."
cd methodes_ensemblistes_notebooks/Python || { echo "Échec de l'accès au répertoire"; exit 1; }

# Lancer Jupyter Notebook
echo "Lancement de Jupyter Notebook..."
jupyter notebook classification_binaire_rf.ipynb || { echo "Échec du lancement de Jupyter"; exit 1; }

echo "Fin du script"

