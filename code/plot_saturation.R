#!/usr/bin/env Rscript

library(tidyverse)
library(ggplot2)

# Define datasets
subsets <- c("1k", "2k", "5k", "10k", "13k", "15k")
results_list <- list()

# Loop through subsets to read performance data
for (s in subsets) {
    file_path <- paste0("results/metalog_bmi_", s, "/performance_results.csv")

    if (file.exists(file_path)) {
        df <- read_csv(file_path, show_col_types = FALSE)
        df$subset_size <- as.numeric(gsub("k", "000", s))
        results_list[[s]] <- df
    } else {
        # Fallback: Read individual run files if aggregated file is missing (e.g. partial run)
        run_dir <- paste0("results/metalog_bmi_", s, "/runs")
        if (dir.exists(run_dir)) {
            run_files <- list.files(path = run_dir, pattern = "_performance\\.csv$", full.names = TRUE)
        } else {
            run_files <- character(0)
        }

        if (length(run_files) > 0) {
            message(paste("Aggregating", length(run_files), "run files for subset:", s))
            df_list <- lapply(run_files, read_csv, show_col_types = FALSE)
            df <- bind_rows(df_list)
            df$subset_size <- as.numeric(gsub("k", "000", s))
            results_list[[s]] <- df
        } else {
            warning(paste("Missing results for:", s))
        }
    }
}

# Combine results
all_results <- bind_rows(results_list)

# Select RMSE (Regression metric)
if ("metric" %in% colnames(all_results)) {
    # Long format
    rmse_results <- all_results %>%
        filter(metric == "RMSE") %>%
        rename(RMSE = performance)
} else {
    # Wide format (what we actually have)
    rmse_results <- all_results %>% select(subset_size, RMSE)
}

# Summarize statistics
summary_stats <- rmse_results %>%
    group_by(subset_size) %>%
    summarize(
        mean_rmse = mean(RMSE),
        sd_rmse = sd(RMSE),
        n = n()
    )

print(summary_stats)

# Plot Saturation Curve
p <- ggplot(summary_stats, aes(x = subset_size, y = mean_rmse)) +
    geom_line(color = "blue", size = 1) +
    geom_point(color = "red", size = 3) +
    geom_errorbar(aes(ymin = mean_rmse - sd_rmse, ymax = mean_rmse + sd_rmse), width = 500) +
    labs(
        title = "Scaling Study: Model Performance vs Sample Size",
        subtitle = "Root Mean Squared Error (RMSE) on Test Set",
        x = "Number of Samples",
        y = "RMSE (Lower is Better)",
        caption = "Error bars represent Standard Deviation across CV folds/seeds"
    ) +
    theme_minimal() +
    scale_x_continuous(breaks = c(1000, 2000, 5000, 10000, 13000, 15000))

ggsave("figures/saturation_curve.png", p, width = 8, height = 6)
message("Saturation plot saved to figures/saturation_curve.png")
