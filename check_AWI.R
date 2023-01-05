# NVC Floristic Tables ----------------------------------------------------
nvcFT_path <- c("Data/NVC-floristic-tables.csv")
nvcFT <- read.csv(file = nvcFT_path)
nvcFT_cleaned <- nvcFT |>
  dplyr::filter(!(Species.name.or.special.variable %in% c("Bryophyte cover %", 
                                                          "Bryophyte height mm", 
                                                          "Ground layer cover %", 
                                                          "Ground layer height mm", 
                                                          "Herb cover %",
                                                          "Herb height cm", 
                                                          "Mean total cover", 
                                                          "Number of species per sample",
                                                          "Shrub cover %", 
                                                          "Shrub height cm", 
                                                          "Shrub height m",
                                                          "Shrub/herb cover %", 
                                                          "Shrub/herb height cm", 
                                                          "Tree cover %",
                                                          "Tree height", 
                                                          "Tree/shrub cover %", 
                                                          "tree/shrub height ",
                                                          "Vegetation cover %", 
                                                          "Vegetation height cm")))
nvcFT_species <- unique(nvcFT_cleaned$Species.name.or.special.variable)
nvcFT_species <- trimws(nvcFT_species)
nvcFT_df <- data.frame("species" = nvcFT_species, "nvcFT" = "Yes")


# BSBI Species Inventory --------------------------------------------------
bsbiInv_path <- "Data/ddb-taxon-list-2022-03-31.xlsx"
bsbiInv <- readxl::read_xlsx(path = bsbiInv_path)
bsbiInv_cleaned <- bsbiInv |>
  dplyr::filter(`GB status` %in% c("native", "native (inferred)"))
bsbiInv_species <- unique(bsbiInv_cleaned$`taxon name`)
bsbiInv_df <- data.frame("species" = bsbiInv_species, "bsbiInv" = "Yes")


# Ancient Woodland Indicators ---------------------------------------------
indAW_path <- "Data/Glaves_2009_AWI_survey.csv"
indAW <- read.csv(file = indAW_path)
indAW_species <- unique(indAW$X)
indAW_df <- data.frame("species" = indAW_species, "indAW" = "Yes")
write.csv(x = indAW, file = "C:/Users/User/Downloads/Glaves2009-AWI.csv")


# PLANTATT ----------------------------------------------------------------
plantATT_path <- "Data/PLANTATT_19_Nov_08.xls"
plantATT <- readxl::read_xls(path = plantATT_path)
plantATT_species <- unique(plantATT$`Taxon name`)
plantATT_df <- data.frame("species" = plantATT_species, "plantATT" = "Yes")


# multiMOVE Niche Models --------------------------------------------------
load("C:/Users/User/OneDrive - University of Leeds/Silviculture/NVC/multiMove/94ae1a5a-2a28-4315-8d4b-35ae964fc3b9/data/MultiMOVE/data/BRCtable.rda")
multiMOVE_species <- unique(BRCtable$BRC_Name)
multiMOVE_df <- data.frame("species" = multiMOVE_species, "multiMOVE" = "Yes")


# Combine Data ------------------------------------------------------------

combined_df <- bsbiInv_df |>
  dplyr::full_join(nvcFT_df, by = "species") |>
  dplyr::full_join(indAW_df, by = "species") |>
  dplyr::full_join(plantATT_df, by = "species") |>
  dplyr::full_join(multiMOVE_df, by = "species")

combined_df_indAW <- combined_df |>
  dplyr::filter(indAW == "Yes")

rownames(combined_df_indAW) <- NULL

