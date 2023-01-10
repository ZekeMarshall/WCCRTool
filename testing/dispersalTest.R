library(AICcmodavg)
library(nlme)

dispeRsal.data_path <- file.path("C:/Users/User/OneDrive - University of Leeds/Silviculture/NVC/Literature",
                                 "/Tamme et al (2014) - Predicting species' maximum dispersal distances from simple plant traits",
                                 "dispeRsal.rda")

dispeRsal.func_path <- file.path("C:/Users/User/OneDrive - University of Leeds/Silviculture/NVC/Literature",
                                 "/Tamme et al (2014) - Predicting species' maximum dispersal distances from simple plant traits",
                                 "dispeRsal_mod.R")

dispeRsal_data <- load(file = dispeRsal.data_path)
source(dispeRsal.func_path)
dispeRsal

test_data <- model.data |>
  dplyr::filter(Species == "Mercurialis perennis") |>
  dplyr::select(-logMax, -FamilyTPL, -OrderTPL) |>
  dplyr::mutate("Order" =  "Malpighiales",
                "Family" = "Euphorbiaceae",
                "Genus" = "Mercurialis")
colnames(model.data)
colnames(own.data)
colnames(test_data)


results <- dispeRsal(data.predict = test_data, model = 4, CI = FALSE, random = TRUE,
                     tax = "family", write.result = FALSE)

results_predictions <- results$predictions

mdd <- 10^results_predictions$log10MDD_measured
