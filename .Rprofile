# Activer l'environnement renv pour le projet
source("renv/activate.R")

# Définir une variable d'environnement pour l'endpoint S3
# Sys.setenv(AWS_S3_ENDPOINT = "minio.lab.sspcloud.fr") # Créer la variable d'environnemnt si elle n'est pas déjà définie
endpoint <- paste0("https://", Sys.getenv("AWS_S3_ENDPOINT")) # inutile si l'on ne souhaite pas charger les données dans un bucket s3)
