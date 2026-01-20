---
title: "ML Results"
date: "2026-01-07"
output:
  html_document:
    keep_md: true
    self_contained: true
    theme: spacelab
params:
  dataset: "metalog_test"
  ml_methods: !r c("glmnet", "rf")
  nseeds: 10
  ncores: 1
  kfold: 2
  config_path: "config/config.yaml"
  find_feature_importance: TRUE
---



# Model Performance


```
## ### Model Performance metrics
```

```
## This figure summarizes the Area Under the Receiver Operating Characteristic (AUROC) curve for each machine learning method. Higher values indicate better predictive performance.
```

<img src="../../figures/metalog_bmi_5k/performance.png" width="100%" />

```
## 
## ### Hyperparameter Tuning
```

```
## These plots show the model performance across different hyperparameter values during the cross-validation phase, identifying the optimal configuration for training.
```

<img src="../../figures/metalog_bmi_5k/hp_performance_glmnet.png" width="100%" /><img src="../../figures/metalog_bmi_5k/feature_importance.png" width="100%" /><img src="../../figures/metalog_bmi_5k/benchmarks.png" width="100%" />
