#!/bin/bash

# Cloner le dépôt GitHub dans le répertoire de travail
git clone https://github.com/InseeFrLab/methodes_ensemblistes_notebooks.git

# Naviguer vers le répertoire contenant le notebook qui nous intéresse
cd methodes_ensemblistes_notebooks/Python

# Lancer le service en ouvrant le notebook qui nous intéresse
jupyter notebook work/methodes_ensemblistes_notebooks/Python/classification_binaire_rf.ipynb
