# UI ----------------------------------------------------------------------

ui <- bs4Dash::dashboardPage(
  
  dark = NULL, # Disable light/dark switch
  
  bs4Dash::bs4DashNavbar(title = tags$div(
    
    tags$img(src="fr.logo.png", width = '175px', style = "padding: 5px !important;
                                                         display: block !important;
                                                         margin-left: auto !important;
                                                         margin-right: auto !important;")),
    
    tags$div("Woodland Flora Translocation Tool (WFTTool)",
             style = "font-size: 25px !important;
                      color: #ffffff !important;
                      align: right !important")),
  
  bs4Dash::bs4DashSidebar(
    minified = FALSE,
    disable = FALSE,
    skin = "light",
    # disable = TRUE,
    width = "250px",
    bs4Dash::bs4SidebarMenu(
      bs4Dash::bs4SidebarMenuItem("WFTTool",
                                  tabName = "wfttool",
                                  badgeLabel = "In Development",
                                  badgeColor = "warning"),
      bs4Dash::bs4SidebarMenuItem("Documentation",
                                  tabName = "documentation",
                                  badgeLabel = "In Development",
                                  badgeColor = "warning")
      
    )
  ),
  body = bs4Dash::bs4DashBody(
    
    # Use custom css
    tags$head(includeCSS("www/style.css")),
    
    # Hide view sidebar control button
    # tags$script("document.getElementsByClassName('navbar-nav')[0].style.visibility = 'hidden';"),
    
    # Call UI component of modules
    bs4Dash::bs4TabItems(
      bs4Dash::bs4TabItem(
        tabName = "wfttool",
        wfttoolUI(id = "wfttool_id_1")
      ),
      bs4Dash::bs4TabItem(
        tabName = "documentation",
        documentationUI(id = "documentation_id_1")
      )
    )
  )
)