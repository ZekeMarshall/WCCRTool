retrieveMDD <- function(species, prediction_level){
  
  taxonomy <- rgbif::name_backbone(name = species, kingdom = 'plants')
  
  spp_data <- model.data |>
    dplyr::filter(Species == species) |>
    dplyr::select(-logMax, -FamilyTPL, -OrderTPL) |>
    dplyr::mutate("Order" =  taxonomy$order,
                  "Family" = taxonomy$family,
                  "Genus" = taxonomy$genus)
  
  results <- dispeRsal(data.predict = spp_data, model = 4, CI = FALSE, random = TRUE,
                       tax = prediction_level, write.result = FALSE)
  
  results_predictions <- results$predictions
  
  mdd <- 10^results_predictions$log10MDD_measured
  
  return(mdd)
  
}