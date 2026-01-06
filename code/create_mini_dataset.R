#!/usr/bin/env Rscript

library(tidyverse)
library(data.table)

# Paths
input_path <- "data/metalog_bmi.csv"
output_path <- "data/metalog_bmi_mini.csv"

message("Loading full dataset...")
# Read the first line to get names, then read a subset or full (data.table is fast)
data <- fread(input_path)

message(paste("Full dimensions:", nrow(data), "x", ncol(data)))

message("Subsampling 500 rows for local testing...")
set.seed(123) # For reproducibility
mini_data <- data %>%
  sample_n(500)

message(paste("Mini dimensions:", nrow(mini_data), "x", ncol(mini_data)))

message("Writing mini dataset...")
write_csv(mini_data, output_path)

message("Done! Saved to:", output_path)
