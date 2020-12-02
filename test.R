r"(C:\Users\woney\Desktop\一个有意思的项目)"-> pathway
setwd(pathway)
dat = readr::read_tsv("all.genes.expression.annot(2).xls")
require(tidyverse)
dat %>% dplyr::select(ends_with("fpkm")) %>% pca_data_tidy() -> re
pca(data = re,
    display_sample = TRUE,
    rename = "replace",
    str_sample = "_.*",
    str_group = "-\\d$",
    add_ploy = TRUE)

