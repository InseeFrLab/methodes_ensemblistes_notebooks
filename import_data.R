# Import data

library(aws.s3) # requêtes s3
library(arrow) # lecture fichiers parquet
library(httr) # barre de progression téléchargement

# Récupérer l'endpoint S3 
# Sys.setenv(AWS_S3_ENDPOINT = "minio.lab.sspcloud.fr") # Créer la variable d'environnemnt si elle n'est pas déjà définie
endpoint <- paste0("https://", Sys.getenv("AWS_S3_ENDPOINT")) # inutile si l'on ne souhaite pas charger les données dans un bucket s3)

# Spécifiez le chemin où sont stockées les données (s3 ou url internet) et le chemin local (où l'on va mettre les données)
local_path <- "data_census_individuals.parquet"

s3_path <- "s3://oliviermeslin/rp/data_census_individuals.parquet"
url = 'https://www.data.gouv.fr/fr/datasets/r/c8e1b241-75fe-43e9-a266-830fc30ec61d'





# Télécharger le fichier 
  # Sepuis S3 vers un fichier local
  save_object(object = s3_path, file = local_path, bucket = "oliviermeslin", opts = list(endpoint = Sys.getenv("AWS_S3_ENDPOINT")))

  # alternative: depuis une adresse url
  download.file(url, destfile = local_path, mode = "wb")
  
  # Vérifier si les données sont déjà présentes en local
  if (file.exists(local_path)) {
    cat("Les données sont déjà téléchargées dans votre espace local.\n")
  } else {
    # Télécharger les données avec une barre de progression si elles ne sont pas présentes
    response <- GET(url, write_disk(local_path, overwrite = TRUE), progress())
    
    # Vérifier si le téléchargement a réussi
    if (status_code(response) == 200) {
      cat("Téléchargement effectué avec succès.\n")
      
      # Lire les données Parquet téléchargées
      data_census_individuals <- read_parquet(local_path)
      
      # Afficher un aperçu des données
      print(head(data_census_individuals))
    } else {
      cat("Le téléchargement a échoué avec le code de statut:", status_code(response), "\n")
    }
  }
  
  
# Charger les données localement avec Arrow
data_census_individuals <- arrow::read_parquet(local_path)

# Afficher un aperçu des données
print(head(data_census_individuals))

