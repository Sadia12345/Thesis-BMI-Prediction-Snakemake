#!/usr/bin/env Rscript

library(dplyr)
library(readr)
library(purrr)

args <- commandArgs(trailingOnly = TRUE)

if (length(args) < 2) {
  stop("Usage: combine_results.R <output_csv> <input_csv_1> [input_csv_2 ...]")
}

output_csv <- args[1]
input_csvs <- args[2:length(args)]

message("Combining ", length(input_csvs), " CSV files into ", output_csv)

input_csvs %>%
  purrr::map_dfr(readr::read_csv) %>%
  readr::write_csv(output_csv)
