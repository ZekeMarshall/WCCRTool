# Server ------------------------------------------------------------------

server <- function(input, output) {

  all_model_data <- callModule(module = wccrtool,
                               id = "wccrtool_id_1")
  
}