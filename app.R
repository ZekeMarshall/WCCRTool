# Load required packages
library(tidyverse)
library(shiny)
library(shinyjs)
# library(shinycssloaders)
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
library(elevatr)

# Required for dispeRsal
library(AICcmodavg)
library(nlme)
#
library(rgbif)


# !!! All the GEOS functions underlying sf need projected coordinates to work properly


# Source utility scripts
source("Utility/constants.R", local = TRUE)
source("Utility/filepaths.R", local = TRUE)
source("Utility/load_data.R", local = TRUE)
source("Utility/render_docs.R", local = TRUE)
# source("Utility/utility_functions.R", local = TRUE)
# source("Utility/menu_options.R", local = TRUE)


# Source model function scripts
source("R/sample_rasterData.R", local = TRUE)
source("R/queryNFIAPI.R", local = TRUE)
source("R/retrieveOccs.R", local = TRUE)
source("R/retrieveMDD.R", local = TRUE)
source("R/retrieveOSA.R", local = TRUE)
source("R/spatialOperations.R", local = TRUE)

# Source App Modules
source("Modules/documentation_ui.R")
source("Modules/wfttool_ui.R", local = TRUE)
source("Modules/wfttool_server.R", local = TRUE)

# Source UI and Server App Modules
source("Modules/ui.R", local = TRUE)
source("Modules/server.R", local = TRUE)


# Run the application
shinyApp(ui = ui, server = server)