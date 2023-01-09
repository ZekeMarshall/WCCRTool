# WFTTool UI -------------------------------------------------------------

wfttoolUI <- function(id) {
  ns <- NS(id)
  
  fluidRow(
    # column(
    #   width = 12,
      shinyjs::useShinyjs(),
      
# Location ----------------------------------------------------------------
      column(
        width = 6,
        bs4Dash::bs4TabCard(
          width = 12,
          collapsible = FALSE,
          id = ns("location.tabbox"),
          
          tabPanel(
            title = "Location",
            value = "location_tab",
            fluidRow(
              leaflet::leafletOutput(
                outputId = ns("map"),
                width = "100%",
                height = 850)
              )),
            
            sidebar = bs4Dash::boxSidebar(
              width = 50,
              startOpen = FALSE,
              background = "#f5f5f5",
              id = ns("map.options"),
              
              tags$h6(tags$b("Grid Reference"), style = "color: black !important"),
              textInput(
                inputId = ns("grid.ref"),
                label = NULL,
                value = NA,
                width = "95%"
                ),
              # tags$h6(tags$b("")),
              actionButton(
                inputId = ns("grid.ref.update"),
                label = "Update",
                style = "margin-top:5px;"
              ),
              tags$h6(tags$b("Longitude"), style = "color: black !important"),
              numericInput(
                inputId = ns("lon"),
                label = NULL,
                value = NA,
                width = "95%"
              ),
              tags$h6(tags$b("Latitude"), style = "color: black !important"),
              numericInput(
                inputId = ns("lat"),
                label = NULL,
                value = NA,
                width = "95%"
              ),
              # tags$h6(tags$b("")),
              actionButton(
                inputId = ns("lon.lat.update"),
                label = "Update",
                style = "margin-top:5px;"
              ),
              tags$h6(tags$b("Eastings"), style = "color: black !important"),
              numericInput(
                inputId = ns("eastings"),
                label = NULL,
                value = NA,
                width = "95%"
              ),
              tags$h6(tags$b("Northings"), style = "color: black !important"),
              numericInput(
                inputId = ns("northings"),
                label = NULL,
                value = NA,
                width = "95%"
              ),
              # tags$h6(tags$b("")),
              actionButton(
                inputId = ns("e.n.update"),
                label = "Update",
                style = "margin-top:5px;"
              ),
              tags$h6(tags$b("Map Type"), style = "color: black !important"),
              selectizeInput(
                inputId = ns("mapType"),
                label = NULL,
                multiple = FALSE,
                choices = map_types,
                selected = "OpenStreetMap",
                width = "95%"
              ),
              tags$h6(tags$b("Map Overlay"), style = "color: black !important"),
              selectizeInput(
                inputId = ns("wms_layer"),
                label = NULL,
                multiple = FALSE,
                choices = wms_layers,
                width = "95%"
              )
          
          )
        
      )),

# Survey Data -------------------------------------------------------------

        column(
          width = 6,
          tabBox(
            width = 12,
            collapsible = FALSE,
            id = ns("variables.tabbox"),
            tabPanel(
              title = "Target Community",
              value = "targetCommunity_tab",
              # tags$head(
              #   tags$style(HTML(" #tabPanel { height:90vh !important; } "))
              # ),
              fluidRow(
                column(width = 12,
                       column(
                         width = 12, 
                         tags$h6(tags$b("Site Status")) |>
                           bsplus::bs_embed_tooltip(title = "Is the site a newly planted woodland, mature woodland, or ancient woodland?", placement = "right"),
                         selectizeInput(inputId = ns("siteStatus"),
                                        label = NULL,
                                        multiple = FALSE,
                                        choices = site_statuses,
                                        width = "95%"),
                         tags$br(),
                         tags$h6(tags$b("Target Woodland Community")) |>
                           bsplus::bs_embed_tooltip(title = "Select Target Community.", placement = "right"),
                         selectizeInput(inputId = ns("targetNVC"),
                                        label = NULL,
                                        multiple = FALSE,
                                        choices = nvc_woodlands,
                                        width = "95%"),
                         tags$br(),
                         tags$h6(tags$b("NVC Survey Data")) |>
                           bsplus::bs_embed_tooltip(title = "Enter NVC Surevy Data Here", placement = "right"),
                         
                         rhandsontable::rHandsontableOutput(outputId = ns("surveyData_table"))
                         
                       )
                )
              )
            ),
            
            
            # Species colonisation assessment -----------------------------------------
            
            tabPanel(
              title = "Colonisation",
              value = "colonisation_tab",
              fluidRow(
                column(width = 12,
                       column(
                         width = 12,
                         selectizeInput(inputId = ns("species"),
                                        label = "Species",
                                        multiple = FALSE,
                                        choices = species.options,
                                        selected = "None Selected"),
                         numericInput(inputId = ns("colonisationRate"),
                                      label = "Maximum Dispersal Distance (MDD) [m/year]",
                                      step = 0.1,
                                      value = 4),
                         numericInput(inputId = ns("colonisationYears"),
                                      label = "Optimal Successional Age (OSA) after establishment [years]",
                                      step = 10,
                                      value = 100),
                         # actionButton(inputId = ns("set_buffer"),
                         #              label = "Establish colonisation buffer"),
                         actionButton(inputId = ns("retrieveForHabNet"),
                                      label = "Retrieve Forest Habitat Network"),
                         actionButton(inputId = ns("retrieveSpeciesOccs"),
                                      label = "Retrieve Species Occurrences")
                         
                       )
                )
              )
            ))
          
        # )
        
  ))
}