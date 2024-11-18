#!/bin/bash

echo "🔄 Initialisation du projet..."

# Déterminer les versions actuelles de Python et Conda
CURRENT_PYTHON_VERSION=$(python --version 2>&1 | awk '{print $2}')
CURRENT_CONDA_VERSION=$(conda --version | awk '{print $2}')

# Définir les versions cibles dynamiquement
TARGET_PYTHON_VERSION=$CURRENT_PYTHON_VERSION
TARGET_CONDA_VERSION=$CURRENT_CONDA_VERSION

echo "📌 Version actuelle de Python : $CURRENT_PYTHON_VERSION"
echo "📌 Version actuelle de Conda : $CURRENT_CONDA_VERSION"

# Vérifier si le fichier environment.yml existe
if [ -f "environment.yml" ]; then
    echo "📄 environment.yml trouvé. Installation des dépendances..."
    conda env update --file environment.yml --prune
    echo "✅ Dépendances installées depuis environment.yml."
else
    echo "⚠️ environment.yml non trouvé. Création d'un nouvel environnement avec Python $TARGET_PYTHON_VERSION..."
    
    # Créer un nouvel environnement Conda avec la version actuelle de Python
    conda create -n projet_meth_ens python=$TARGET_PYTHON_VERSION -y
    
    # Charger le hook de Conda et activer l'environnement
    source "$(conda info --base)/etc/profile.d/conda.sh"
    conda activate projet_meth_ens
    
    echo "📦 Installation des bibliothèques de base..."
    conda install -y pip numpy pandas matplotlib boto3 requests pyarrow tqdm scikit-learn
    echo "✅ Bibliothèques de base installées."
    
    echo "📄 Création du fichier environment.yml..."
    conda env export --no-builds > environment.yml
    echo "✅ environment.yml créé avec Python $TARGET_PYTHON_VERSION."
fi

# Vérifier et figer la version de Conda si nécessaire
echo "🔍 Vérification de la version de Conda..."
if [ "$CURRENT_CONDA_VERSION" != "$TARGET_CONDA_VERSION" ]; then
    echo "📦 Mise à jour de Conda à la version $TARGET_CONDA_VERSION..."
    conda install -n base conda=$TARGET_CONDA_VERSION -y
    echo "✅ Conda mis à jour à la version $TARGET_CONDA_VERSION."
else
    echo "✅ Conda est déjà à la version $TARGET_CONDA_VERSION."
fi

# Vérifier et installer nbstripout si nécessaire
echo "🔍 Vérification de l'installation de nbstripout..."
if ! conda run -n projet_meth_ens command -v nbstripout &> /dev/null; then
    echo "📦 Installation de nbstripout via pip..."
    conda run -n projet_meth_ens pip install nbstripout
    echo "✅ nbstripout installé avec succès."
else
    echo "✅ nbstripout est déjà installé."
fi

# Ajouter nbstripout manuellement dans environment.yml si nécessaire
if ! grep -q "nbstripout" environment.yml; then
    echo "📄 Mise à jour de environment.yml pour inclure nbstripout..."
    if grep -q "\- pip:" environment.yml; then
        # Ajouter nbstripout à la section pip existante
        sed -i '/- pip:/a\    - nbstripout' environment.yml
    else
        # Ajouter une nouvelle section pip si elle n'existe pas
        echo "  - pip:" >> environment.yml
        echo "    - nbstripout" >> environment.yml
    fi
    echo "✅ nbstripout ajouté dans environment.yml."
else
    echo "✅ nbstripout est déjà inclus dans environment.yml."
fi

# Configuration de nbstripout pour le dépôt Git
if [ -d ".git" ]; then
    echo "⚙️ Configuration de nbstripout pour le dépôt Git..."
    nbstripout --install
    if [ $? -eq 0 ]; then
        echo "✅ nbstripout configuré pour nettoyer les sorties des notebooks avant les commits."
    else
        echo "❌ Erreur lors de la configuration de nbstripout pour le dépôt Git."
    fi
else
    echo "⚠️ Aucun dépôt Git détecté. Skipping nbstripout configuration."
fi

echo "🚀 Initialisation terminée."
