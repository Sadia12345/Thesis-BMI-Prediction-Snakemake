#!/usr/bin/env Rscript

library(tidyverse)
library(data.table)

# Paths
metadata_path <- "data/metalog/human_core_wide_2025-12-28.tsv"
abundance_path <- "data/metalog/human_metaphlan4_species_2025-12-28.tsv"
output_path <- "data/metalog_bmi.csv"

message("Loading metadata...")
metadata <- fread(metadata_path) %>%
  select(sample_alias, bmi, age_years, sex) %>%
  filter(!is.na(bmi)) %>%
  filter(!is.na(age_years)) %>%
  filter(!is.na(sex)) %>%
  mutate(sex = as.factor(sex)) 
  # Note: Weight and Height excluded to prevent leakage.

message(paste("Metadata loaded. Valid samples with BMI:", nrow(metadata)))

message("Loading abundance data (this may take a moment)...")
# Read only necessary columns if possible, but data.table is fast
abundance <- fread(abundance_path, select = c("sample_alias", "species", "rel_abund"))

message("Filtering abundance data to match valid metadata samples...")
abundance <- abundance[sample_alias %in% metadata$sample_alias]

message("Pivoting to wide format...")
abundance_wide <- dcast(abundance, sample_alias ~ species, value.var = "rel_abund", fill = 0)

message("Merging metadata and microbiome data...")
final_data <- inner_join(metadata, abundance_wide, by = "sample_alias")

message(paste("Final dataset dimensions:", nrow(final_data), "samples x", ncol(final_data), "features"))

message("Writing to CSV...")
write_csv(final_data, output_path)

message("Done! File saved to: ", output_path)
