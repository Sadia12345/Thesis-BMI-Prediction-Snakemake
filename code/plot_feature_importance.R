#!/usr/bin/env Rscript

library(mikropml)
library(tidyverse)
library(caret)
library(ggplot2)

# Define paths
model_path <- "results/metalog_bmi_10k/runs/glmnet_100_model.Rds"
output_plot <- "figures/feature_importance_10k.png"

# Check if model exists
if (!file.exists(model_path)) {
    stop(paste("Model file not found:", model_path))
}

message("Loading model...")
model <- readRDS(model_path)

message("Extracting feature importance (caret::varImp)...")
# caret::varImp handles glmnet models by returning absolute coefficients
imp <- caret::varImp(model)$importance
imp$feat <- rownames(imp)
colnames(imp)[1] <- "Importance"

# Filter for top 20 features
top_features <- imp %>%
    arrange(desc(Importance)) %>%
    slice_head(n = 20)

print(head(top_features))

# Plot
p <- ggplot(top_features, aes(x = reorder(feat, Importance), y = Importance)) +
    geom_bar(stat = "identity", fill = "steelblue") +
    coord_flip() +
    labs(
        title = "Top 20 Predictive Features (BMI)",
        subtitle = "Standardized Coefficients (10k Sample Model)",
        x = "Microbial Feature",
        y = "Importance (Absolute Coefficient)"
    ) +
    theme_minimal()

ggsave(output_plot, p, width = 10, height = 8)
message(paste("Saved plot to:", output_plot))
