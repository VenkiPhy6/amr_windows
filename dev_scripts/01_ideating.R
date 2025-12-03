rm(list=ls())
pacman::p_load(tidyverse, duckdb)

## ----------------------------------
## Get SureChEMBL data

dbfile <- file.path("./data/surechembl_20250925/surechembl.duckdb")
con <- dbConnect(duckdb::duckdb(dbfile), read_only = FALSE)

# dbExecute(con, "CREATE TABLE pat_to_comp AS SELECT * FROM 'data/surechembl_20250925/patent_compound_map.parquet'")
# dbExecute(con, "CREATE TABLE comp AS SELECT * FROM 'data/surechembl_20250925/compounds.parquet'")
# dbExecute(con, "CREATE TABLE fld AS SELECT * FROM 'data/surechembl_20250925/fields.parquet'")
# dbExecute(con, "CREATE TABLE pat AS SELECT * FROM 'data/surechembl_20250925/patents.parquet'")
# dbExecute(con, "
#   UPDATE my_table
#   SET my_list_col = list_transform(my_list_col, x -> trim(x));
# ")

dbExecute(con, "SET memory_limit='23GB';")

## ----------------------------------
## Get AntibioticDB data

# adb <- read.csv("./data/adb_20250926/manual_fixed_adb.csv")
# proper_colnames <- colnames(adb)  |> tolower()  |> str_replace_all("\\s|\\-", "_")  |> str_replace_all("(\\(|\\))", "")
# colnames(adb) <- proper_colnames
# dbWriteTable(con, "adb", adb)

tbl(con, "adb") |> glimpse()


## --------------------------------------------
## Mapping Drug classes to Murray et al. (2022)

tbl(con, "adb") |> 
  select(drug.class) |> 
  distinct() |> 
  collect() |> 
  arrange(drug.class) |> 
  View()

tbl(con, "adb") |>
  collect() |> 
  filter(grepl('aminopenicillin', drug.class)) |> 
  select(drug.name , main.source, drug.class) |> 
  View()

tbl(con, "adb") |>
  collect() |> 
  filter(grepl('inhibitor', drug.class)) |> 
  select(drug.name , main.source, drug.class) |> 
  View()

tbl(con, "adb") |> 
  select(main.source) |> 
  distinct() |> 
  collect() |> 
  arrange(main.source) |> 
  View()
