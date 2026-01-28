# BMI Prediction from Microbiome: A Scaling and Saturation Study

## Project Overview
This repository contains the complete computational framework for my Master's thesis. The project investigates the scalability and optimization of machine learning (ML) models for predicting Body Mass Index (BMI) using taxonomic profiles from human gut metagenomes.

The workflow is built for **reproducibility** and **transparency**, following the best practices suggested by the ML4Microbiome consortium.

## Key Research Outcomes
This study directly addresses the research questions regarding model saturation and computational optimization:

### 1. The Saturation Point
Through a wide-scale scaling study (1k to 15k samples, 100 seeds per subset), we identified a clear **saturation point at 13,000 samples**. 
- **RMSE at 13k:** 5.70
- **RMSE at 15k:** 5.78 (plateau)

### 2. Computational Optimization
- **Feature Prefiltering:** A 1% prevalence filter reduced the feature space from ~6,300 to ~1,500 species, accelerating training without loss of accuracy.
- **Workflow Automation:** A Snakemake pipeline that parallelizes 100 random seeds for robust statistical evaluation.

## Data Acquisition & Preparation

The pipeline expects processed CSV files in the `data/` directory. If starting from raw Metalog datasets, follow these steps:

### 1. Raw Data Placement
Place your taxonomic and metadata files in `data/metalog/`:
- `data/metalog/human_core_wide_YYYY-MM-DD.tsv` (Metadata with BMI)
- `data/metalog/human_metaphlan4_species_YYYY-MM-DD.tsv` (Relative Abundance)

### 2. Data Cleaning & Filtering
Run the preparation script to merge datasets, remove leakage variables (Weight/Height), and apply prevalence filtering:
```bash
Rscript code/prepare_metalog_data.R
```
This generates `data/metalog_bmi_filtered.csv`, which serves as the base for the Snakemake subsets.

## Repository Structure
- **`workflow/`**: The core Snakemake logic (rules, scripts, envs).
- **`config/`**: YAML settings for model type (Lasso, RF, XGB) and data paths.
- **`code/`**: Standalone R scripts for dataset preparation and subsetting.
- **`bin/`**: Helper scripts for performance aggregation.
- **`data/`**: Storage for raw and processed datasets.
- **`figures/`**: Output directory for saturation curves and feature importance plots.

## How to Run the Pipeline

### 1. Setup Environment
```bash
conda env create -f workflow/envs/mikropml.yml
conda activate mikropml
```

### 2. Configure the Run
Update `config/config.yaml` to point to your data:
```yaml
dataset_csv: data/metalog_bmi_13k.csv
outcome_colname: bmi
```

### 3. Execute
```bash
snakemake --cores all
```

## Scientific Rigor: Data Leakage Prevention
To ensure valid biological predictions, the workflow strictly enforces:
1. **Target Leakage Removal:** Weight and Height are explicitly removed from features.
2. **Confounding Control:** Age and Sex are excluded to isolate the microbial signal.
3. **Robustness:** 100 random seeds are used to evaluate model stability.
