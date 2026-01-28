# BMI Prediction from Microbiome: A Scaling and Saturation Study

## Project Overview
This repository contains the complete computational framework for my Master's thesis. The project investigates the scalability and optimization of machine learning (ML) models for predicting Body Mass Index (BMI) using taxonomic profiles from human gut metagenomes.

The workflow is built for **reproducibility** and **transparency**, following the best practices suggested by the ML4Microbiome consortium.

## Key Research Outcomes
This study directly addresses the research questions regarding model saturation and computational optimization:

### 1. The Saturation Point
Through a wide-scale scaling study (1k to 15k samples, 100 seeds per subset), we identified a clear **saturation point at 13,000 samples**. 
- **Finding:** Performance (RMSE) improves significantly as data increases to 10k, but adding further samples (up to 15k) yields diminishing returns for taxonomic signal prediction.
- **RMSE at 13k:** 5.70
- **RMSE at 15k:** 5.78 (plateau)

### 2. Computational Optimization
To satisfy the requirement for high-throughput analysis on standard hardware, we implemented:
- **Feature Prefiltering:** A 1% prevalence filter was applied, reducing the feature space from ~6,300 to ~1,500 species, significantly accelerating training without loss of accuracy.
- **Workflow Automation:** A Snakemake pipeline that parallelizes 100 random seeds for robust statistical evaluation.

## Repository Structure
- **`workflow/`**: The core Snakemake logic.
  - `rules/`: Modular analysis steps (preprocessing, training, plotting).
  - `scripts/`: R scripts for the `mikropml` implementation and visualization.
  - `envs/`: Conda environment definitions.
- **`config/`**: YAML configuration files to switch between models (Lasso, RF, XGBoost) and dataset sizes.
- **`code/`**: Standalone R scripts for dataset preparation and pilot studies.
- **`bin/`**: Helper scripts for performance aggregation.
- **`data/`**: (Input Directory) Reserved for the Metalog dataset files.
- **`figures/`**: Output directory for generated saturation curves and feature importance plots.

## Technical Stack
- **Workflow Manager:** Snakemake
- **Statistical Computing:** R (mikropml, glmnet, randomForest, xgboost)
- **Reproducibility:** Conda / Mamba

## How to Run the Pipeline

### 1. Setup Environment
Ensure you have Conda or Mamba installed. Create the required environment:
```bash
conda env create -f workflow/envs/mikropml.yml
conda activate mikropml
```

### 2. Configure the Run
Modify `config/config.yaml` to select the desired model type (e.g., `glmnet`) and outcome variable.

### 3. Execute
To run the full pipeline using all available CPU cores:
```bash
snakemake --cores all
```

## Scientific Rigor: Data Leakage Prevention
To ensure valid biological predictions, the preprocessing script (`workflow/scripts/preproc.R`) strictly enforces:
1. **Target Leakage Removal:** Weight and Height are explicitly removed from features (as they are direct components of BMI).
2. **Confounding Control:** Age and Sex are excluded to isolate the microbial signal.
3. **Cross-Validation:** 100 random seeds are used to evaluate model stability.
