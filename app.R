# Load required packages
library(tidyverse)
library(shiny)
library(shinyjs)
# library(shinyalert)
# library(shinyWidgets)
library(leaflet)
library(leafpm)
library(geojsonsf)
library(leafem)
library(rgbif)
library(bsplus)
library(bs4Dash)
library(sgo)
library(rhandsontable)
library(sf)
library(sfheaders)
# library(DT)
# library(plotly)
library(rmarkdown)
# library(knitr)
# library(kableExtra)
# library(htmltools)
# library(htmlwidgets)
# library(hablar)

# Source utility scripts
source("Utility/constants.R", local = TRUE)
source("Utility/filepaths.R", local = TRUE)
source("Utility/render_docs.R", local = TRUE)
# source("Utility/utility_functions.R", local = TRUE)
# source("Utility/menu_options.R", local = TRUE)

# Source model function scripts
source("R/sample_rasterData.R", local = TRUE)
source("R/retrieve_Occs.R", local = TRUE)

# Source App Modules
source("Modules/documentation_ui.R")
source("Modules/wccrtool_ui.R", local = TRUE)
source("Modules/wccrtool_server.R", local = TRUE)

# Source UI and Server App Modules
source("Modules/ui.R", local = TRUE)
source("Modules/server.R", local = TRUE)


# Run the application
shinyApp(ui = ui, server = server)