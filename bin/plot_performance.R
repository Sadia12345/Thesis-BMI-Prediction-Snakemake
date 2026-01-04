#!/usr/bin/env Rscript

# Ensure libraries can be loaded, if not, print error and quit gracefully
# Ensure libraries can be loaded
tryCatch({
    library(dplyr)
    library(readr)
    library(ggplot2)
    library(mikropml)
}, error = function(e) {
    message("Error loading libraries: ", e$message)
    quit(status=1)
})

args <- commandArgs(trailingOnly = TRUE)

if (length(args) < 2) {
  stop("Usage: plot_performance.R <input_csv> <output_plot_file>")
}

input_csv <- args[1]
output_plot <- args[2]

message("Plotting performance from ", input_csv, " to ", output_plot)

tryCatch({
    if (!file.exists(input_csv)) {
        stop("Input CSV not found: ", input_csv)
    }

    perf_data <- read_csv(input_csv)
    
    if (nrow(perf_data) == 0) {
        stop("Input CSV is empty!")
    }

    # Plot
    p <- mikropml::plot_model_performance(perf_data) +
      theme_classic() +
      scale_color_brewer(palette = "Dark2") +
      coord_flip()

    ggsave(output_plot, plot = p, width=8, height=6)
    message("Successfully saved plot to ", output_plot)
    
}, error = function(e) {
    message("Failed to create plot: ", e$message)
    # Don't fail the pipeline for a plot, but warn
    file.create(output_plot) # Create empty file to prevent pipeline crash
})
