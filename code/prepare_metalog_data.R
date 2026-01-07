#!/usr/bin/env Rscript

library(tidyverse)
library(data.table)

# Paths
metadata_path <- "data/metalog/human_core_wide_2025-12-28.tsv"
abundance_path <- "data/metalog/human_metaphlan4_species_2025-12-28.tsv"
output_path <- "data/metalog_bmi_filtered.csv"

message("Loading metadata...")
metadata <- fread(metadata_path) %>%
  select(sample_alias, bmi) %>%
  filter(!is.na(bmi))
# Note: Weight and Height excluded to prevent leakage.

message(paste("Metadata loaded. Valid samples with BMI:", nrow(metadata)))

message("Loading abundance data (this may take a moment)...")
# Read only necessary columns if possible, but data.table is fast
abundance <- fread(abundance_path, select = c("sample_alias", "species", "rel_abund"))

message("Filtering abundance data to match valid metadata samples...")
abundance <- abundance[sample_alias %in% metadata$sample_alias]

message("Performing Prevalence Filtering...")
# Calculate prevalence (percentage of samples where species is present > 0)
total_samples <- nrow(metadata)
prevalence <- abundance[, .(prev = sum(rel_abund > 0) / total_samples), by = species]
total_species <- nrow(prevalence)
keep_species <- prevalence[prev >= 0.01]$species
filtered_species_count <- length(keep_species)

message(paste("Total Species:", total_species))
message(paste("Species keeping (>1% prevalence):", filtered_species_count))
message(paste("Species removed:", total_species - filtered_species_count))

abundance <- abundance[species %in% keep_species]

message("Pivoting to wide format...")
abundance_wide <- dcast(abundance, sample_alias ~ species, value.var = "rel_abund", fill = 0)


message("Merging metadata and microbiome data...")
final_data <- inner_join(metadata, abundance_wide, by = "sample_alias")

message(paste("Final dataset dimensions:", nrow(final_data), "samples x", ncol(final_data), "features"))

message("Writing to CSV...")
write_csv(final_data, output_path)

message("Done! File saved to: ", output_path)
