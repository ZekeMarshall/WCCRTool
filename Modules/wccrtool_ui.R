# WCCRTool UI -------------------------------------------------------------

wccrtoolUI <- function(id) {
  ns <- NS(id)
  
  fluidRow(
    column(
      width = 12,
      shinyjs::useShinyjs(),

      tabBox(
        width = 12,
        collapsible = FALSE,
        id = ns("wccrtool.tabbox"),
        

# Documentation -----------------------------------------------------------

        tabPanel(
          title = "Documentation",
          value = "documentation_tab",
          htmltools::tags$iframe(src = "WCCRTool_documentation.html",
                                 width = '100%',
                                 height = 1000,
                                 style = "border:none;") 
        ),
        
# Location ----------------------------------------------------------------
        tabPanel(
          title = "Location",
          value = "location_tab",
          fluidRow(
            tags$head(
              tags$style(HTML("input[type=number] {-moz-appearance:textfield;}
                              input[type=number]::{-moz-appearance:textfield;}
                              input[type=number]::-webkit-outer-spin-button,
                              input[type=number]::-webkit-inner-spin-button {-webkit-appearance: none;margin: 0;}"))
            ),
            column(
              width = 10,
              fluidRow(
                column(
                  width = 2,
                  textInput(
                    inputId = ns("grid.ref"),
                    label = "Grid Reference",
                    value = NA
                  ),
                  style = "padding-right:0px;"
                ),
                column(
                  width = 1,
                  actionButton(
                    inputId = ns("grid.ref.update"),
                    label = "Update",
                    style = "margin-top:32px; margin-left:0px;"
                  )
                ),
                column(
                  width = 1,
                  numericInput(
                    inputId = ns("lon"),
                    label = "Longitude",
                    value = NA
                  )
                ),
                column(
                  width = 1,
                  numericInput(
                    inputId = ns("lat"),
                    label = "Latitude",
                    value = NA
                  ),
                  style = "padding-right:0px;"
                ),
                column(
                  width = 1,
                  actionButton(
                    inputId = ns("lon.lat.update"),
                    label = "Update",
                    style = "margin-top:32px; margin-left:0px;"
                  )
                ),
                column(
                  width = 1,
                  numericInput(
                    inputId = ns("eastings"),
                    label = "Eastings",
                    value = NA
                  )
                ),
                column(
                  width = 1,
                  numericInput(
                    inputId = ns("northings"),
                    label = "Northings",
                    value = NA
                  ),
                  style = "padding-right:0px;"
                ),
                column(
                  width = 1,
                  actionButton(
                    inputId = ns("e.n.update"),
                    label = "Update",
                    style = "margin-top:32px; margin-left:0px;"
                  )
                )
              )
            ),
            column(
              width = 1,
              selectizeInput(
                inputId = ns("mapType"),
                label = "Map Type",
                multiple = FALSE,
                choices = map_types,
                selected = "Esri.WorldImagery",
                width = "90%"
              )
            ),
            column(
              width = 1,
              column(
                width = 12,
                selectizeInput(
                  inputId = ns("wms_layer"),
                  label = "Map Overlay",
                  multiple = FALSE,
                  choices = wms_layers,
                  width = "90%"
                )
              )
            )
          ),
          leaflet::leafletOutput(
            outputId = ns("map"),
            width = "100%",
            height = 750
          )
        ),
        

# Survey Data -------------------------------------------------------------
        tabPanel(
          title = "Survey Data",
          value = "surveyData_tab",
          # tags$head(
          #   tags$style(HTML(" #tabPanel { height:90vh !important; } "))
          # ),
          fluidRow(
            column(width = 12,
                   column(
                     width = 12,
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
                       width = 12
                       
                     )
              )
            )
          )
        
        
        
  )))
}