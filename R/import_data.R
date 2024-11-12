# Import data

################################################################################

# Fonction de téléchargement des données depuis S3 ou une URL avec barre de progression
download_data <- function(local_path, url = NULL, s3_path = NULL, bucket = NULL, endpoint = NULL) {
  
  # Vérifier si le dossier du chemin local existe, sinon le créer
  dir_path <- dirname(local_path)
  if (!dir.exists(dir_path)) {
    dir.create(dir_path, recursive = TRUE)
  }
  
  # Vérifier si les données sont déjà présentes en local
  if (file.exists(local_path)) {
    cat("Les données sont déjà téléchargées dans votre espace local.\n")
    return(invisible(NULL))  # Sortir de la fonction si les données sont déjà présentes
  }
  
  # Télécharger les données depuis S3
  if (!is.null(s3_path) && !is.null(bucket) && !is.null(endpoint)) {
    cat("Téléchargement depuis le bucket S3...\n")

    # Télécharger depuis S3 avec tryCatch pour gérer les erreurs
    success <- tryCatch({
      save_object(object = s3_path, 
                  file = local_path, 
                  bucket = bucket, 
                  opts = list(endpoint = Sys.getenv("AWS_S3_ENDPOINT")))
      TRUE
    }, error = function(e) {
      cat("Le téléchargement depuis S3 a échoué:", e$message, "\n")
      FALSE
    })
    
    if (success) {
      cat("Téléchargement effectué avec succès depuis S3.\n")
    } else {
      return(invisible(NULL))
    }
    
    # Télécharger les données depuis une URL
  } else if (!is.null(url)) {
    cat("Téléchargement depuis l'URL...\n")
    
    # Télécharger depuis l'URL avec une barre de progression
    response <- GET(url, write_disk(local_path, overwrite = TRUE), httr::progress())
    
    # Vérifier si le téléchargement a réussi
    if (status_code(response) == 200) {
      cat("Téléchargement effectué avec succès depuis l'URL.\n")
    } else {
      cat("Le téléchargement a échoué avec le code de statut:", httr::status_code(response), "\n")
      return(invisible(NULL))
    }
  } else {
    cat("Ni URL, ni chemin S3 spécifié. Impossible de télécharger les données.\n")
    return(invisible(NULL))
  }
  
  # Retourner un message de succès après téléchargement
  if (file.exists(local_path)) {
    cat("Fichier téléchargé et enregistré à :", local_path, "\n")
  }
  
  return(invisible(NULL))  # Retourner NULL si le fichier est déjà là ou si une erreur survient
}


# Fonction pour lire les fichiers Parquet avec Arrow (après téléchargement)
read_parquet_data <- function(local_path) {
  if (file.exists(local_path)) {
    data <- arrow::read_parquet(local_path)
    cat("Données Parquet chargées avec succès depuis :", local_path, "\n")
    return(data)
  } else {
    cat("Le fichier n'existe pas à l'emplacement spécifié :", local_path, "\n")
    return(NULL)
  }
}


# Fonction pour lire les fichiers CSV avec un délimiteur ';'
read_csv_data <- function(local_path) {
  if (file.exists(local_path)) {
    data <- read.csv(local_path, sep = ";")
    cat("Données CSV chargées avec succès depuis :", local_path, "\n")
    return(data)
  } else {
    cat("Le fichier n'existe pas à l'emplacement spécifié :", local_path, "\n")
    return(NULL)
  }
}

################################################################################

# Téléchargement des fichiers en local

  # Depuis un bucket S3
  download_data(local_path = "data/data_census_individuals.parquet", 
                s3_path = "rp/data_census_individuals.parquet", 
                bucket = "oliviermeslin", 
                endpoint = "https://minio.lab.sspcloud.fr")
  
  download_data(local_path = "data/data_census_dwellings.parquet", 
                s3_path = "rp/data_census_dwellings.parquet", 
                bucket = "oliviermeslin", 
                endpoint = "https://minio.lab.sspcloud.fr")
  
  # Depuis une adresse URL
  download_data(local_path = "data/data_census_individuals.parquet", 
                url = "https://www.data.gouv.fr/fr/datasets/r/c8e1b241-75fe-43e9-a266-830fc30ec61d")
  
  download_data(local_path = "data/data_census_dwellings.parquet", 
                url = "https://www.data.gouv.fr/fr/datasets/r/f314175a-6d33-4ee4-b5eb-2cb6c29df2c2")
  
  download_data(local_path = "documentation/doc_census_individuals.csv", 
                url = "https://www.data.gouv.fr/fr/datasets/r/1c6c6ab2-b766-41a4-90f0-043173d5e9d1")
  
  download_data(local_path = "documentation/doc_census_dwellings.csv", 
                url = "https://www.data.gouv.fr/fr/datasets/r/c274705f-98db-4d9b-9674-578e04f03198")
  
  
# Lecture des fichiers Parquet avec Arrow (après téléchargement)
data_census_individuals <- read_parquet_data(local_path = "data/data_census_individuals.parquet")
data_census_dwellings <- read_parquet_data(local_path = "data/data_census_dwellings.parquet")

doc_census_individuals <- read_csv_data(local_path = "documentation/doc_census_individuals.csv")
doc_census_dwellings <- read_csv_data(local_path = "documentation/doc_census_dwellings.csv")


# Afficher un aperçu des données
print(head(data_census_individuals))
print(head(data_census_dwellings))


