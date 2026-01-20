# Snakemake Workflow for Microbiome-Based BMI Prediction

## Thesis Project Overview
This repository contains the reproducible computational workflow for my Master's thesis. The goal of this project is to develop machine learning models that predict Body Mass Index (BMI) from human gut microbiome taxonomic profiles.

By leveraging the mikropml R package within a Scalable Snakemake workflow, this project ensures that all analysis metrics - from data preprocessing to model evaluation - are transparent, reproducible, and scalable.

## Project Status
- Current State: Pipeline Validated and Scaling Study Complete.
  - The workflow has been executed on dataset subsets ranging from 1,000 to 15,000 samples to assess scalability.
  - Reproducibility verified on local hardware.
- Next Phase: Final thesis submission.

## Results Summary
The scaling study (1,000 to 15,000 samples, 100 seeds each) confirmed the **Saturation Hypothesis**:
- **13,000 samples:** Achieved optimal performance (RMSE **5.70**).
- **15,000 samples:** Performance plateaued (RMSE **5.78**), indicating diminishing returns.
- **Conclusion:** 13k samples capture the maximal predictive signal for BMI in this dataset.

## Methodology
The analysis follows a rigorous machine learning framework:
1. Data Preprocessing: Cleaning and normalizing taxonomic count data.
2. Model Selection: Comparing linear models (GLMNet/Lasso).
3. Validation: employing k-fold cross-validation with multiple random seeds to ensure robustness.
4. Reporting: Automatically generating HTML reports with Performance curves and feature importance lists.

## Data Strategy and Leakage Prevention
To ensure scientifically valid results, the data preparation process (code/prepare_metalog_data.R) enforces the following rules:

### 1. Data Selection
- Merge Source: Combines metadata with microbiome abundance.
- Filter: Retains only samples with valid BMI (Outcome).

### 2. Confounding Control
- Demographics Excluded: Age and Sex are explicitly removed from the feature set to ensure the model relies solely on microbial signals.

### 3. Leakage Prevention
- Weight and Height: EXPLICITLY REMOVED.
- Reason: Since BMI = Weight / Height^2, including these variables would cause "Target Leakage," allowing the model to predict BMI mathematically without learning any biological patterns.

## Technical Stack
- Workflow Manager: Snakemake (Python-based)
- Machine Learning: mikropml (R package)
- Environment: Conda (environment.yml included)
- Reporting: RMarkdown

## Repository Structure
- config/             # Configuration settings
- data/               # Raw and processed data inputs
- workflow/           # Snakemake rules and scripts
- workflow/rules/     # Modular rule definitions
- workflow/scripts/   # R scripts for training and plotting
- results/            # Generated model outputs (Not tracked)
- figures/            # Generated plots (Not tracked)

## How to Run
To reproduce the analysis on your local machine:

1. Install Dependencies:
   conda env create -f workflow/envs/environment.yml
   conda activate snakemake

2. Run Pipeline:
   # Runs the workflow using available cores
   snakemake --cores 1
