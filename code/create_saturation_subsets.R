#!/usr/bin/env Rscript

library(data.table)
library(tidyverse)

input_path <- "data/metalog_bmi_filtered.csv"
set.seed(42) # For reproducibility

if (!file.exists(input_path)) {
    stop("Filtered dataset not found! Run prepare_metalog_data.R first.")
}

message("Loading filtered dataset...")
data <- fread(input_path)
total_n <- nrow(data)
message(paste("Total samples:", total_n))

sizes <- c(1000, 2000, 5000, 10000, 13000, 15000)

for (n in sizes) {
    if (n <= total_n) {
        message(paste("Creating subset: n =", n))
        subset_data <- data %>% sample_n(n)
        output_file <- paste0("data/metalog_bmi_", n / 1000, "k.csv")
        write_csv(subset_data, output_file)
        message(paste("Saved:", output_file))
    } else {
        message(paste("Skipping n =", n, "(larger than total dataset)"))
    }
}

message("Done generating subsets.")
