retrieveOSA <- function(species){
  
  osa_data_spp <- osa_data |>
    dplyr::filter(Taxon == species) |>
    dplyr::pull(`Value`)
  
  return(osa_data_spp)
  
}