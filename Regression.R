# Premier exemple de régression: prédire l'âge

#install.packages("renv")
#renv::init() #  initialise renv dans le projet (crée un fichier renv.lock et un dossier renv/ où les packages spécifiques à ce projet seront installés)
#renv::snapshot() # inspecte le projet pour capturer tous les packages nécessaires et les versions dans renv.lock.
#renv::restore() # lit le fichier renv.lock et installe les packages spécifiés à leurs versions respectives dans l'environnement isolé.

# Charger des packages nécessaires
library(tidyverse) # Pour la manipulation des données
library(Rcpp)
library(ranger) # Pour la Random Forest
library(plyr)
library(caret)  # Pour la validation croisée et la gestion des données
library(readr)
library(arrow)


# Charger les données
data_census_individuals <- read_parquet("data/data_census_individuals.parquet")

# Exploration des données
str(data_census_individuals)  # Voir la structure des données pour comprendre les types de variables

# Sélection aléatoire de 1/20è des données
set.seed(123)  # Pour la reproductibilité
data_sample <- data_census_individuals %>% sample_frac(1/25)

# Suppression des variables liées à l'âge (AGER20, AGEREV, AGEREVQ, ANAI)
data_clean <- data_sample %>%
  select(-AGER20, -AGEREV, -AGEREVQ, -ANAI,
         -TRIRIS, -IRIS, -DNAI, -DEPT, -ARM,
         -CANTVILLE, -NUMMI) # on supprime les variables avec trop de modalités pour commencer
  

# Encodage des variables catégorielles
str(data_clean)

data_clean <- data_clean %>%
  mutate_if(is.character, as.factor)

# Séparer les données en features (X) et la variable cible (y : AGED)
X <- data_clean %>% select(-AGED)
y <- data_clean$AGED

# Diviser les données en ensembles d'entraînement et de test
set.seed(123)  # Pour la reproductibilité
trainIndex <- createDataPartition(y, p = .8, 
                                  list = FALSE, 
                                  times = 1)
X_train <- X[trainIndex, ]
y_train <- y[trainIndex]
X_test  <- X[-trainIndex, ]
y_test  <- y[-trainIndex]

# Modèle Random Forest avec le package ranger
set.seed(123)  # Pour la reproductibilité
start_time <- Sys.time() # Démarrer le compteur de temps

rf_model <- ranger(
  formula = y_train ~ .,
  data = X_train,
  importance = 'impurity',  # On calcule l'importance des variables avec la réduction d'impureté
  num.trees = 500,
  mtry = floor(sqrt(ncol(X_train))),  # Nombre de variables sélectionnées pour chaque arbre
  min.node.size = 5,  # Taille minimale des nœuds
  seed = 123
)

end_time <- Sys.time()
elapsed_time <- end_time - start_time # Calculer le temps écoulé
cat("Temps d'exécution du modèle Random Forest :", elapsed_time, "\n") # Afficher le temps écoulé

# Prédictions sur les données de test
y_pred <- predict(rf_model, data = X_test)$predictions

# Évaluer la performance : Erreur quadratique moyenne (RMSE)
rmse <- sqrt(mean((y_test - y_pred)^2))
print(paste("RMSE: ", rmse))

# Validation croisée
cv_control <- trainControl(method = "cv", number = 10)
rf_cv_model <- train(
  y_train ~ .,
  data = X_train,
  method = "ranger",
  trControl = cv_control,
  importance = "impurity"
)

# Importance des variables (Mean Decrease in Impurity et Mean Decrease Accuracy)
importance <- importance(rf_model)
importance_sorted <- importance[order(importance, decreasing = TRUE)]
print(importance_sorted)

# Graphique d'importance des variables
varImpPlot(rf_model)

# Importance des variables basée sur la précision (Mean Decrease Accuracy)
importance_accuracy <- rf_cv_model$finalModel$variable.importance
print(importance_accuracy)

