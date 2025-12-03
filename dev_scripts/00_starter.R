library(shinylive)
library(here)

setwd(file.path(here()))

# Run the app directory
shinylive::export(appdir = "./dev_scripts/00_starter", destdir = "./docs")

httpuv::runStaticServer("./dev_scripts/00_docs/", port=8008)
