#!/usr/bin/env Rscript

library(tidyverse)
library(ggplot2)

# File path for 2k dataset results
results_file <- "results/metalog_bmi_2k/performance_results.csv"

if (!file.exists(results_file)) {
    stop("Results file not found. Ensure Snakemake run is complete.")
}

# Read results
results <- read_csv(results_file, show_col_types = FALSE)

# Filter for RMSE and cleanup method names
plot_data <- results %>%
    filter(metric == "RMSE") %>%
    mutate(method = case_when(
        method == "glmnet" ~ "Lasso (glmnet)",
        method == "rf" ~ "Random Forest",
        method == "xgbTree" ~ "XGBoost",
        TRUE ~ method
    ))

# Calculate summary stats
summary_stats <- plot_data %>%
    group_by(method) %>%
    summarize(
        mean_rmse = mean(performance),
        sd_rmse = sd(performance),
        n = n()
    )
print(summary_stats)

# Create Comparison Plot
p <- ggplot(plot_data, aes(x = method, y = performance, fill = method)) +
    geom_boxplot(alpha = 0.7) +
    geom_jitter(width = 0.2, alpha = 0.4) +
    labs(
        title = "Model Comparison: Linear vs Non-Linear (2k Samples)",
        subtitle = "RMSE Distribution across 100 Random Seeds",
        x = "Machine Learning Model",
        y = "RMSE (Lower is Better)",
        caption = "Dataset: metalog_bmi_2k | Methods: Lasso vs Random Forest"
    ) +
    theme_minimal() +
    scale_fill_brewer(palette = "Set2") +
    theme(legend.position = "none")

# Save detailed plot
ggsave("figures/model_comparison.png", p, width = 6, height = 5)
message("Saved comparison plot to figures/model_comparison.png")
