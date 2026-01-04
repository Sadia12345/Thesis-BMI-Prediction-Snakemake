# Microbiome-Based BMI Prediction Pipeline

## Thesis Project Overview
This repository contains the reproducible computational workflow for my Master's thesis. The goal of this project is to develop machine learning models that predict Body Mass Index (BMI) from human gut microbiome taxonomic profiles.

By leveraging the `mikropml` R package within a Scalable Snakemake workflow, this project ensures that all analysis metrics—from data preprocessing to model evaluation—are transparent, reproducible, and scalable to high-performance computing (HPC) environments.

## 🚀 Project Status
- **Current State:** ✅ Pipeline Logic Verified
  - The complete Snakemake workflow has been successfully implemented and tested on a subset of the data (`metalog_test`).
  - Key components (preprocessing, training, evaluation, reporting) are functional.
  - Environment dependencies (R, Conda) are fully resolved.
- **Next Phase:** 🚧 Full Scale Analysis
  - Execution on the full `metalog_bmi` dataset.
  - Deployment to CSC Supercomputer environment.
  - Deeper hyperparameter tuning and interpretation of feature importance.

## 🔬 Methodology
The analysis follows a rigorous machine learning framework:
1.  **Data Preprocessing:** Cleaning and normalizing taxonomic count data.
2.  **Model Selection:** Comparing linear models (GLMNet/Lasso) and non-linear models (Random Forest).
3.  **Validation:** employing k-fold cross-validation (default k=2 for testing, k=10 for production) with multiple random seeds splits to ensure robustness.
4.  **Reporting:** Automatically generating HTML reports with Performance curves (ROC/PR) and feature importance lists.

## 🛠️ Technical Stack
- **Workflow Manager:** [Snakemake](https://snakemake.github.io) (Python-based)
- **Machine Learning:** [mikropml](https://github.com/SchlossLab/mikropml) (R package)
- **Environment:** Conda (environment.yml included)
- **Reporting:** RMarkdown

## 📂 Repository Structure
```
.
├── config/             # Configuration settings (dataset selection, ML parameters)
├── data/               # Raw and processed data inputs
├── workflow/           # Snakemake rules and scripts
│   ├── rules/          # Modular rule definitions
│   └── scripts/        # R scripts for training and plotting
├── results/            # (Ignored) Generated model outputs
└── figures/            # (Ignored)Generated plots and visualizations
```

## 💻 How to Run
To reproduce the analysis on your local machine:

1.  **Install Dependencies:**
    ```bash
    conda env create -f workflow/envs/environment.yml
    conda activate snakemake
    ```

2.  **Run Pipeline (Test Mode):**
    ```bash
    # Runs the workflow on test data using 8 cores
    snakemake --cores 8
    ```

3.  **View Report:**
    Open `report_metalog_test.html` generated in the root directory.

## 📅 Roadmap for Completion
| Milestone | Description | Status |
|-----------|-------------|--------|
| **Phase 1** | Setup Snakemake workflow & dependencies | ✅ Complete |
| **Phase 2** | Verify logic with test dataset | ✅ Complete |
| **Phase 3** | Run full analysis on local/HPC | 🔜 Next Step |
| **Phase 4** | Complete Thesis Writing & Interpretation | 📅 Planned |
