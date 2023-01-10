# Load required data
osa_data <- read.csv(file = optimal.successional.age_path)
dispeRsal_data <- load(file = dispeRsal.data_path, envir = sys.frame())
rm(dispeRsal)
source(dispeRsal.func_path)

# dispeRsalv2.data_path <- paste0("C:/Users/User/OneDrive - University of Leeds/",
#                                 "Silviculture/NVC/Literature/",
#                                 "Chen et al (2019) - Seeds tend to disperse further in the tropics/",
#                                 "dispeRsal/dispeRsal.rda")
# 
# dispeRsal_data <- load(file = dispeRsalv2.data_path, envir = sys.frame())
