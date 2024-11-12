# Premier exemple de classification: prédire le niveau de diplôme

################################################################################

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
data_census_individuals <- read_parquet_data(local_path = "data/data_census_individuals.parquet")

# Exploration des données
str(data_census_individuals)  # Voir la structure des données pour comprendre les types de variables

# Sélection aléatoire au 1/100è des données
set.seed(123)  # Pour la reproductibilité
data_sample <- data_census_individuals %>% sample_frac(1/100)

# Suppression des variables liées à l'âge (AGER20, AGEREV, AGEREVQ, ANAI)
data_clean <- data_sample %>%
  select(-AGER20, -AGEREV, -AGEREVQ, -ANAI,
         -TRIRIS, -IRIS, -DNAI, -DEPT, -ARM,
         -CANTVILLE, -NUMMI, -IPONDI) # on supprime les variables avec trop de modalités pour commencer

# Voir la répartition des classes de diplôme
sum(is.na(data_clean$DIPL))
table(data_clean$DIPL)

table(data_clean$DIPL, data_clean$CS1)
tableau_croise <- table(data_clean$DIPL, data_clean$CS1)
prop.table(tableau_croise, margin = 2) * 100


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

# Calculer les poids en fonction de l'inverse des fréquences dans y_train
class_weights <- table(y_train)
class_weights <- 1 / class_weights
class_weights <- class_weights / sum(class_weights)  # Normaliser pour que la somme soit égale à 1

# Modèle Random Forest pour classification avec le package ranger
set.seed(123)  # Pour la reproductibilité
start_time <- Sys.time() # Démarrer le compteur de temps

rf_model <- ranger(
  formula = y_train ~ .,
  data = X_train,
  importance = 'impurity',
  num.trees = 500,
  mtry = floor(sqrt(ncol(X_train))),
  min.node.size = 5,
  class.weights = class_weights,
  seed = 123
)

end_time <- Sys.time()
elapsed_time <- end_time - start_time # Calculer le temps écoulé
cat("Temps d'exécution du modèle Random Forest :", elapsed_time, "\n") # Afficher le temps écoulé

# Prédictions sur les données de test
predictions <- predict(rf_model, data = X_test)

# Récupérer directement les prédictions de classe
y_pred_class <- factor(predictions$predictions, levels = levels(y_test))

# Évaluer la performance avec une matrice de confusion
conf_matrix <- confusionMatrix(y_pred_class, y_test)
print(conf_matrix)

# Visualiser la matrice de confusion avec ggplot2
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

# Affichage des xx variables les plus importantes (10 variables les plus importantes par défaut)
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
# cv_control <- trainControl(method = "cv", number = 10)
# rf_cv_model <- train(
#   y_train ~ .,
#   data = X_train,
#   method = "ranger",
#   trControl = cv_control,
#   importance = "impurity"
# )

# Importance des variables basée sur la précision (Mean Decrease Accuracy)
# importance_accuracy <- rf_cv_model$finalModel$variable.importance
# print(importance_accuracy)














