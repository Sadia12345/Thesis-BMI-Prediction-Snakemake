#!/usr/bin/env Rscript

library(mikropml)
library(readr)
library(doFuture)

args <- commandArgs(trailingOnly = TRUE)

if (length(args) < 3) {
  stop("Usage: preproc.R <input_csv> <outcome_colname> <output_rds> [ncores]")
}

input_csv <- args[1]
outcome_colname <- args[2]
output_rds <- args[3]
ncores <- if (length(args) > 3) as.numeric(args[4]) else 1

# Register parallel backend
registerDoFuture()
plan(future::multisession, workers = ncores)
options(future.globals.maxSize = 4000 * 1024^2) # Increase limit to 4GB

message("Reading data from: ", input_csv)
data_raw <- readr::read_csv(input_csv)

message("Preprocessing data with outcome: ", outcome_colname)
data_processed <- preprocess_data(data_raw, outcome_colname = outcome_colname)

message("Saving processed data to: ", output_rds)
saveRDS(data_processed, file = output_rds)
