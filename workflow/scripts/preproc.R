schtools::log_snakemake()
library(mikropml)

library(data.table)

future::plan(future::sequential)
options(future.globals.maxSize = Inf) # Unlimited memory for future

# Use fread for memory efficiency (returns base data.frame with data.table=FALSE)
data_raw <- data.table::fread(snakemake@input[["csv"]], data.table = FALSE)
data_processed <- preprocess_data(data_raw, outcome_colname = snakemake@params[["outcome_colname"]])

saveRDS(data_processed, file = snakemake@output[["rds"]])
