#!/bin/bash

echo "🔄 Initialisation du projet..."

# Vérifier si le fichier environment.yml existe
if [ -f "environment.yml" ]; then
    echo "📄 environment.yml trouvé. Installation des dépendances..."
    conda env update --file environment.yml --prune
    echo "✅ Dépendances installées depuis environment.yml."
else
    echo "⚠️ environment.yml non trouvé. Installation des bibliothèques de base..."
    conda install -y numpy pandas matplotlib boto3 requests pyarrow tqdm scikit-learn
    echo "✅ Bibliothèques de base installées."

    echo "📄 Création du fichier environment.yml..."
    conda env export --no-builds > environment.yml
    echo "✅ environment.yml créé."
fi

# Vérifier et installer nbstripout si nécessaire
echo "🔍 Vérification de l'installation de nbstripout..."
if ! command -v nbstripout &> /dev/null; then
    echo "📦 Installation de nbstripout via pip..."
    pip install nbstripout
    echo "✅ nbstripout installé avec succès."
else
    echo "✅ nbstripout est déjà installé."
fi

# Configuration de nbstripout pour le dépôt Git
if [ -d ".git" ]; then
    echo "⚙️ Configuration de nbstripout pour ce dépôt Git..."
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
