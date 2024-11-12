# Script de configuration initiale du projet: bibliothèques et environnement

# Vérifier si renv est installé ; si non, l'installer automatiquement
if (!requireNamespace("renv", quietly = TRUE)) {
  install.packages("renv")
}

# Charger le package renv
library(renv)

# Restaurer l'environnement renv à partir du fichier renv.lock si disponible
if (file.exists("renv.lock")) {
  renv::restore(prompt = FALSE)  # Restauration sans confirmation
} else {
  # Initialisation de l'environnement renv si renv.lock n'existe pas
  renv::init(bare = TRUE)
  
  # Installation des packages nécessaires pour le projet si c'est une nouvelle configuration
  renv::install(c("aws.s3", "arrow", "httr", "tidyverse", "Rcpp", "ranger", "plyr", "caret", "readr", "ggplot2"))
  
  # Snapshot de l'environnement pour générer renv.lock
  renv::snapshot()
}