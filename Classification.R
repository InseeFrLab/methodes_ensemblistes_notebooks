# Premier exemple de classification: prédire le niveau de diplôme

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
library(ggplot2)

# Charger les données
data_census_individuals <- read_parquet("data/data_census_individuals.parquet")

# Exploration des données
str(data_census_individuals)  # Voir la structure des données pour comprendre les types de variables

# Sélection aléatoire de 1/20è des données
set.seed(123)  # Pour la reproductibilité
data_sample <- data_census_individuals %>% sample_frac(1/200)

# Suppression des variables liées à l'âge (AGER20, AGEREV, AGEREVQ, ANAI)
data_clean <- data_sample %>%
  select(-AGER20, -AGEREV, -AGEREVQ, -ANAI,
         -TRIRIS, -IRIS, -DNAI, -DEPT, -ARM,
         -CANTVILLE, -NUMMI) # on supprime les variables avec trop de modalités pour commencer


# Encodage des variables catégorielles
str(data_clean)

data_clean <- data_clean %>%
  mutate_if(is.character, as.factor)

# Séparer les données en features (X) et la variable cible (y : DIPL)
X <- data_clean %>% select(-DIPL)
y <- data_clean$DIPL

# Diviser les données en ensembles d'entraînement et de test
set.seed(123)  # Pour la reproductibilité
trainIndex <- createDataPartition(y, p = .8, list = FALSE, times = 1)
X_train <- X[trainIndex, ]
y_train <- y[trainIndex]
X_test  <- X[-trainIndex, ]
y_test  <- y[-trainIndex]

# Modèle Random Forest pour classification avec le package ranger
set.seed(123)  # Pour la reproductibilité
start_time <- Sys.time() # Démarrer le compteur de temps

rf_model <- ranger(
  formula = y_train ~ .,   # Classification de la variable DIPL
  data = X_train,
  importance = 'impurity',  # Calcul de l'importance des variables
  num.trees = 500,
  mtry = floor(sqrt(ncol(X_train))),  # Nombre de variables sélectionnées pour chaque arbre
  min.node.size = 5,  # Taille minimale des nœuds
  probability = TRUE,  # Indiquer que nous faisons une classification probabiliste
  seed = 123
)

end_time <- Sys.time()
elapsed_time <- end_time - start_time # Calculer le temps écoulé
cat("Temps d'exécution du modèle Random Forest :", elapsed_time, "\n") # Afficher le temps écoulé

# Prédictions sur les données de test
predictions <- predict(rf_model, data = X_test)

# Prédictions des classes
y_pred_class <- predictions$predictions %>% apply(1, which.max) %>% as.factor()

# Évaluer la performance avec la matrice de confusion
conf_matrix <- confusionMatrix(y_pred_class, y_test)
print(conf_matrix)

# Visualiser la matrice de confusion avec ggplot2
library(caret)
cm_df <- as.data.frame(conf_matrix$table)
ggplot(cm_df, aes(x = Reference, y = Prediction, fill = Freq)) +
  geom_tile() +
  geom_text(aes(label = Freq)) +
  scale_fill_gradient(low = "white", high = "blue") +
  labs(title = "Matrice de confusion pour la prédiction du niveau de diplôme",
       x = "Classe réelle",
       y = "Classe prédite") +
  theme_minimal()

# Importance des variables (Mean Decrease in Impurity)
importance_df <- data.frame(
  Variable = names(rf_model$variable.importance),
  Importance = rf_model$variable.importance
)

# Affichage des 10 variables les plus importantes
plot_top_n_variables <- function(importance_df, n = 10) {
  # Trier par importance
  importance_df_sorted <- importance_df %>%
    arrange(desc(Importance)) %>%
    head(n)
  
  # Afficher les n variables les plus importantes
  print(importance_df_sorted)
  
  # Visualisation
  ggplot(importance_df_sorted, aes(x = reorder(Variable, Importance), y = Importance)) +
    geom_bar(stat = "identity", fill = "steelblue") +
    coord_flip() +
    labs(title = paste("Top", n, "variables les plus importantes"),
         x = "Variable",
         y = "Importance") +
    theme_minimal()
}

# Afficher les 10 variables les plus importantes
plot_top_n_variables(importance_df, 10)

# Validation croisée
cv_control <- trainControl(method = "cv", number = 10)
rf_cv_model <- train(
  y_train ~ .,
  data = X_train,
  method = "ranger",
  trControl = cv_control,
  importance = "impurity"
)

# Importance des variables basée sur la précision (Mean Decrease Accuracy)
importance_accuracy <- rf_cv_model$finalModel$variable.importance
print(importance_accuracy)














