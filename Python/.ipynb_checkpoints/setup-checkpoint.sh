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


