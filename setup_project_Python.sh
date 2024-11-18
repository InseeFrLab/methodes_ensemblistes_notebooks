#!/bin/bash

echo "🔄 Initialisation du projet..."

# Charger Conda
source "$(conda info --base)/etc/profile.d/conda.sh"

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
    conda env update --file environment.yml --prune || {
        echo "❌ Erreur : Impossible de mettre à jour l'environnement depuis environment.yml."
        exit 1
    }
    echo "✅ Dépendances installées depuis environment.yml."
else
    echo "⚠️ environment.yml non trouvé. Création d'un nouvel environnement avec Python $TARGET_PYTHON_VERSION..."
    
    # Créer un nouvel environnement Conda avec la version actuelle de Python
    conda create -n projet_meth_ens python=$TARGET_PYTHON_VERSION -y || {
        echo "❌ Erreur : Échec de la création de l'environnement Conda."
        exit 1
    }
    
    echo "📦 Installation des bibliothèques de base..."
    conda install -n projet_meth_ens -y numpy pandas matplotlib boto3 requests pyarrow tqdm scikit-learn nbstripout || {
        echo "❌ Erreur : Échec de l'installation des bibliothèques de base."
        exit 1
    }
    echo "✅ Bibliothèques de base et nbstripout installés."

    echo "📄 Création du fichier environment.yml..."
    conda activate projet_meth_ens
    conda env export --no-builds > environment.yml || {
        echo "❌ Erreur : Échec de la création du fichier environment.yml."
        exit 1
    }
    echo "✅ environment.yml créé avec Python $TARGET_PYTHON_VERSION."
fi

# Activer l'environnement
echo "🔍 Activation de l'environnement 'projet_meth_ens'..."
conda activate projet_meth_ens || {
    echo "❌ Erreur : Impossible d'activer l'environnement 'projet_meth_ens'."
    exit 1
}
echo "✅ Environnement 'projet_meth_ens' activé."

# Vérifier et figer la version de Conda si nécessaire
echo "🔍 Vérification de la version de Conda..."
if [ "$CURRENT_CONDA_VERSION" != "$TARGET_CONDA_VERSION" ]; then
    echo "📦 Mise à jour de Conda à la version $TARGET_CONDA_VERSION..."
    conda install -n base conda=$TARGET_CONDA_VERSION -y || {
        echo "❌ Erreur : Échec de la mise à jour de Conda."
        exit 1
    }
    echo "✅ Conda mis à jour à la version $TARGET_CONDA_VERSION."
else
    echo "✅ Conda est déjà à la version $TARGET_CONDA_VERSION."
fi

# Configuration de nbstripout pour le dépôt Git
if [ -d ".git" ]; then
    echo "⚙️ Configuration de nbstripout pour le dépôt Git..."
    conda run -n projet_meth_ens nbstripout --install || {
        echo "❌ Erreur : Échec de la configuration de nbstripout pour Git."
        exit 1
    }
    echo "✅ nbstripout configuré pour nettoyer les sorties des notebooks avant les commits."
else
    echo "⚠️ Aucun dépôt Git détecté. Configuration de nbstripout ignorée."
fi

echo "🚀 Initialisation terminée."
