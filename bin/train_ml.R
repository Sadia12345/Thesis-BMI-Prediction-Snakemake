#!/usr/bin/env Rscript

library(mikropml)
library(dplyr)
library(readr)
library(doFuture)

args <- commandArgs(trailingOnly = TRUE)

if (length(args) < 6) {
  stop("Usage: train_ml.R <input_rds> <method> <seed> <outcome_colname> <kfold> <output_dir> [ncores] [hyperparams]")
}

input_rds <- args[1]
method <- args[2]
seed <- as.numeric(args[3])
outcome_colname <- args[4]
kfold <- as.numeric(args[5])
output_dir <- args[6]
ncores <- if (length(args) > 6) as.numeric(args[7]) else 1
# Hyperparams parsing could be more complex, simplification for now:
hyperparams <- NULL 
# In a real scenario, we might pass a JSON string or path to a YAML for hyperparams

# Create output filenames
output_model <- file.path(output_dir, paste0(method, "_", seed, "_model.Rds"))
output_perf  <- file.path(output_dir, paste0(method, "_", seed, "_performance.csv"))
output_test  <- file.path(output_dir, paste0(method, "_", seed, "_test-data.csv"))

# Register parallel backend
registerDoFuture()
plan(future::multicore, workers = ncores)

message("Loading processed data from: ", input_rds)
data_processed <- readRDS(input_rds)$dat_transformed

message(paste0("Running ML: Method=", method, ", Seed=", seed))

ml_results <- mikropml::run_ml(
  dataset = data_processed,
  method = method,
  outcome_colname = outcome_colname,
  find_feature_importance = FALSE, # Done separately usually, or can be enabled
  kfold = kfold,
  seed = seed,
  hyperparameters = hyperparams
)

message("Saving results...")
# Enrich performance with metadata
wildcards_df <- data.frame(method = method, seed = seed)
perf_df <- ml_results$performance %>%
  inner_join(wildcards_df, by = character()) # Cross join effectively if no by, but here simple addition

readr::write_csv(perf_df, output_perf)
readr::write_csv(ml_results$test_data, output_test)
saveRDS(ml_results$trained_model, file = output_model)
