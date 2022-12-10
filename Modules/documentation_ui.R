# Documentation -----------------------------------------------------------
documentationUI <- function(id) {
  ns <- NS(id)
  
  fluidRow(
    column(
      width = 12,
      tabBox(
        width = 12,
        collapsible = FALSE,
        id = ns("variables.tabbox"),
        tabPanel(
          title = "Documentation",
          value = "documentation_tab",
          htmltools::tags$iframe(src = "WCCRTool_documentation.html",
                                 width = '100%',
                                 height = 1000,
                                 style = "border:none;") 
        ))))
}