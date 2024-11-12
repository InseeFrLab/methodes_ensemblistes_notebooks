# Premier exemple de régression: prédire l'âge

################################################################################

# Charger les données
data_census_individuals <- read_parquet("data/data_census_individuals.parquet")

# Exploration des données
str(data_census_individuals)  # Voir la structure des données pour comprendre les types de variables

# Sélection aléatoire au 1/200è des données
set.seed(123)  # Pour la reproductibilité
data_sample <- data_census_individuals %>% sample_frac(1/200)

# Suppression des variables liées à l'âge (AGER20, AGEREV, AGEREVQ, ANAI)
data_clean <- data_sample %>%
  select(-AGER20, -AGEREV, -AGEREVQ, -ANAI,
         -TRIRIS, -IRIS, -DNAI, -DEPT, -ARM,
         -CANTVILLE, -NUMMI, -IPONDI) # on supprime les variables avec trop de modalités pour commencer
  

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

# Évaluer la performance : graphique de dispersion
results <- data.frame(
  Age_Real = y_test,          # Âge réel
  Age_Predicted = y_pred      # Âge prédit par la Random Forest
)

ggplot(results, aes(x = Age_Real, y = Age_Predicted)) +
  geom_point(color = 'blue', alpha = 0.5) +  # Points de dispersion
  geom_abline(intercept = 0, slope = 1, color = 'red', linetype = "dashed") +  # Ligne y = x (référence)
  labs(title = "Âge prédit vs Âge réel",
       x = "Âge réel",
       y = "Âge prédit") +
  theme_minimal()

# Validation croisée
cv_control <- trainControl(method = "cv", number = 10)
rf_cv_model <- train(
  y_train ~ .,
  data = X_train,
  method = "ranger",
  trControl = cv_control,
  importance = "impurity"
)

# Importance des variables (Mean Decrease in Impurity)

  # Extraire l'importance des variables depuis le modèle ranger
  importance_df <- data.frame(
    Variable = names(rf_model$variable.importance),
    Importance = rf_model$variable.importance
  )
  
  # Associer les libellés (descriptions) des variables depuis le dictionnaire
  doc_census_individuals_noms_variables <- doc_census_individuals %>%
    select(COD_VAR, LIB_VAR)
  doc_census_individuals_noms_variables <- doc_census_individuals_noms_variables %>%
    distinct()
  
  importance_df_with_labels <- importance_df %>%
    left_join(doc_census_individuals_noms_variables, by = c("Variable" = "COD_VAR"))
  
  # Trier les variables par importance décroissante
  importance_df_sorted <- importance_df_with_labels %>%
    arrange(desc(Importance))
  
  # Graphique d'importance des variables
  ggplot(importance_df_with_labels, aes(x = reorder(LIB_VAR, Importance), y = Importance)) +
    geom_bar(stat = "identity", fill = "steelblue") +
    coord_flip() +  # Inverser les axes pour faciliter la lecture
    labs(title = "Importance des variables (Mean Decrease in Impurity)",
         x = "Variable",
         y = "Importance") +
    theme_minimal()

  # Afficher le top XX des variables les plus importantes avec leurs descriptions
    plot_top_n_variables <- function(importance_df_with_labels, n = 10) {
        
      # Sélectionner les n variables les plus importantes
      importance_df_sorted <- importance_df_with_labels %>%
        arrange(desc(Importance))
      
        top_n_variables <- importance_df_sorted %>%
          head(n)
        
      # Afficher les n variables les plus importantes
      print(top_n_variables)
      
      # Visualiser graphiquement les n variables les plus importantes
      ggplot(top_n_variables, aes(x = reorder(LIB_VAR, Importance), y = Importance)) +
        geom_bar(stat = "identity", fill = "steelblue") +
        coord_flip() +  # Inverser les axes pour faciliter la lecture
        labs(title = paste("Top", n, "variables les plus importantes (Mean Decrease in Impurity)"),
             x = "Variable",
             y = "Importance") +
        theme_minimal()
    }
    
      plot_top_n_variables(importance_df_with_labels, n = 10)
      plot_top_n_variables(importance_df_with_labels, n = 20)
      
  

# Importance des variables basée sur la précision (Mean Decrease Accuracy)
importance_accuracy <- rf_cv_model$finalModel$variable.importance
print(importance_accuracy)


  
  
