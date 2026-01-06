schtools::log_snakemake()
library(mikropml)

future::plan(future::sequential)
options(future.globals.maxSize = 4000 * 1024^2) # Increase limit to 4GB

data_raw <- readr::read_csv(snakemake@input[["csv"]])
data_processed <- preprocess_data(data_raw, outcome_colname = snakemake@params[["outcome_colname"]])

saveRDS(data_processed, file = snakemake@output[["rds"]])
