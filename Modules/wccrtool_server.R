wccrtool <- function(input, output, session) {
  
  ns <- session$ns
  
  # Create Leaflet map ------------------------------------------------------
  
  output$map <- leaflet::renderLeaflet({
    leaflet::leaflet() |>
      leaflet::addProviderTiles(leaflet::providers[as.character(input$mapType)] |> unname() |> unlist()) |>
      leaflet::setView(
        lng = -2.2,
        lat = 55,
        zoom = 6
      ) |>
      leafpm::addPmToolbar(
        toolbarOptions = leafpm::pmToolbarOptions(drawMarker = FALSE, 
                                                  position = "topleft"),
        drawOptions = leafpm::pmDrawOptions(snappable = FALSE, 
                                            allowSelfIntersection = FALSE),
        editOptions = leafpm::pmEditOptions(preventMarkerRemoval = FALSE, 
                                            draggable = FALSE),
        cutOptions = leafpm::pmCutOptions(snappable = FALSE, 
                                          allowSelfIntersection = FALSE)
      )
  })
  
  
  # Add WMS layers to map ---------------------------------------------------
  
  observe({
    
    if(input$wms_layer == "none"){
      
      leaflet::leafletProxy("map") |>
        leaflet::clearGroup(group = "wms_tiles") |>
        leafem::addMouseCoordinates()
        # leafem::addGeotiff(file = terra::rast(x = airQuality_path)|>
        #                      terra::project("EPSG:3857"), 
        #                    opacity = 0.9, 
        #                    colorOptions = colorOptions(palette = hcl.colors(256, palette = "inferno"), 
        #                                                na.color = "transparent"))
      
    } else {
      
      leaflet::leafletProxy("map") |>
        leaflet::clearGroup(group = "wms_tiles") |>
        leaflet::clearControls() |>
        leaflet::addWMSTiles(
          wms_url,
          group = "wms_tiles",
          layers = input$wms_layer, # "at"
          options = WMSTileOptions(
            transparent = TRUE,
            opacity = 0.5,
            format = "image/png"
          )
        ) |>
        leaflet::addControl(paste0("<img src=", wms_legend_url, input$wms_layer, ">"), position = "topright")
      # leaflet.extras::addWMSLegend(uri = paste0(wms_legend_url, input$wms_layer),
      #                              position = "topright",
      #                              layerId = "legend")
    }
    
  }) |>
    bindEvent(input$wms_layer)
  
  
  # Store map click data ----------------------------------------------------
  
  click_rval <- reactiveVal()
  
  observe({
    click <- input$map_click
    
    # leaflet::leafletProxy("map") |>
    #   leaflet::clearMarkers() |>
    #   leaflet::addMarkers(
    #     lng = click$lng,
    #     lat = click$lat
    #   )
    
    click_rval(click)
  }) |>
    bindEvent(input$map_click)
  
  
# Retrieve user-supplied polygon ------------------------------------------
  
  sitePolygon_3857 <- reactiveVal()
  # sitePolygon_4326 <- reactiveVal()
  
  observe({
    
    feature <- input$map_draw_new_feature
    feature_sf_3857 <- geojsonsf::geojson_sf(jsonify::to_json(feature, unbox = T))
    # feature_sf_4326 <- feature_sf_3857 |>
    #   sf::st_transform(sf::st_crs(4326))

    sitePolygon_3857(feature_sf_3857)
    # sitePolygon_4326(feature_sf_4326)
    
  }) |>
    bindEvent(input$map_draw_new_feature)
  

# Create Search Area ------------------------------------------------------
  searchArea_3857 <- reactiveVal()
  searchArea_4326 <- reactiveVal()
  
  observe({
    
    sitePolygon_3857 <- sitePolygon_3857()
    
    sitePolygonBuffer_3857 <- create_searchAreaPolygon(polygon = sitePolygon_3857,
                                                       colonisationRate = input$colonisationRate,
                                                       colonisationYears = input$colonisationYears)
    
    sitePolygonBuffer_4326 <- sitePolygonBuffer_3857 |>
      sf::st_transform(sf::st_crs(4326))
    
    searchArea_3857(sitePolygonBuffer_3857)
    searchArea_4326(sitePolygonBuffer_4326)
    
  }) |>
    bindEvent(sitePolygon_3857(), input$colonisationRate, input$colonisationYears, ignoreInit = TRUE)


# Plot Search Area --------------------------------------------------------

  observe({

    searchArea_3857 <- searchArea_3857()

    if(is.null(searchArea_3857)){

      leaflet::leafletProxy("map")

    } else {

      leaflet::leafletProxy("map") |>
        leaflet::addPolygons(data = searchArea_3857,
                             color = "#35B779",
                             weight = 3,
                             fillOpacity = 0,
                             opacity = 1,
                             layerId = "searchArea")
    }

  }) |>
    bindEvent(searchArea_3857())
  
# Retrieve species occurrences --------------------------------------------
  
  speciesOccs <- reactiveVal()

  observe({

    searchArea_4326 <- searchArea_4326()

    occs_df <- retrieve_NBNOccurrences(species = input$species,
                                       searchArea = searchArea_4326)

    speciesOccs(occs_df)

  }) |>
    bindEvent(input$retrieveSpeciesOccs)
  

# Plot species occurrences ------------------------------------------------

  observe({

    speciesOccs <- speciesOccs()

    if(is.null(searchArea_3857) | nrow(speciesOccs) == 0){

      leaflet::leafletProxy("map")

    } else {

      leaflet::leafletProxy("map") |>
        leaflet::clearMarkers() |>
        leaflet::addMarkers(lng = speciesOccs$lng, lat = speciesOccs$lat,
                            # icon = ~ icons(
                            #   iconUrl = sprintf("https://leafletjs.com/examples/custom-icons/leaf-%s.png", group),
                            #   iconWidth = 19, iconHeight = 42,
                            #   iconAnchorX = 22, iconAnchorY = 94,
                            #   popupAnchorX = -3, popupAnchorY = -76
                            # ),
                            popup = NULL,
                            popupOptions = NULL,
                            label = NULL,
                            labelOptions = NULL)
    }

  }) |>
    bindEvent(speciesOccs())
  
# Update location input boxes based on click values -----------------------
  
  observe({
    click <- input$map_click
    
    click_bng <- sgo::sgo_points(list(
      longitude = as.numeric(click$lng),
      latitude = as.numeric(click$lat)
    ), epsg = 4326) |>
      sgo::sgo_lonlat_bng()
    
    click_ngr <- click_bng |>
      sgo::sgo_bng_ngr()
    
    # Update eastings input
    updateNumericInput(session,
                       inputId = "eastings",
                       value = as.numeric(click_bng$x)
    )
    
    # Update northings input
    updateNumericInput(session,
                       inputId = "northings",
                       value = as.numeric(click_bng$y)
    )
    
    # Update latitude input
    updateNumericInput(session,
                       inputId = "lat",
                       value = as.numeric(click$lat)
    )
    
    # Update longitude input
    updateNumericInput(session,
                       inputId = "lon",
                       value = as.numeric(click$lng)
    )
    
    # Update grid reference input
    updateTextInput(session,
                    inputId = "grid.ref",
                    value = click_ngr$ngr
    )
  }) |>
    bindEvent(input$map_click)
  
  
  # Update location input boxes based on grid reference value ---------------
  
  observe({
    
    new.grid.ref <- input$grid.ref
    
    new.grid.ref_bng <- sgo::sgo_ngr_bng(new.grid.ref)
    
    new.grid.ref_lonlat <- new.grid.ref_bng |>
      sgo::sgo_bng_lonlat()
    
    # Update eastings input
    updateNumericInput(session,
                       inputId = "eastings",
                       value = as.numeric(new.grid.ref_bng$x)
    )
    
    # Update northings input
    updateNumericInput(session,
                       inputId = "northings",
                       value = as.numeric(new.grid.ref_bng$y)
    )
    
    # Update latitude input
    updateNumericInput(session,
                       inputId = "lat",
                       value = as.numeric(new.grid.ref_lonlat$y)
    )
    
    # Update longitude input
    updateNumericInput(session,
                       inputId = "lon",
                       value = as.numeric(new.grid.ref_lonlat$x)
    )
    
    # Update click position
    leaflet::leafletProxy("map") |>
      leaflet::clearMarkers() |>
      leaflet::addMarkers(
        lng = new.grid.ref_lonlat$x,
        lat = new.grid.ref_lonlat$y
      )
    
  }) |>
    bindEvent(input$grid.ref.update)
  
  # Update location input boxes based on lat and lon values ---------------
  
  observe({
    
    new.lon.lat <- list("lon" = input$lon, "lat" = input$lat)
    
    new.lon.lat_bng <- sgo::sgo_points(list(
      longitude = as.numeric(new.lon.lat$lon),
      latitude = as.numeric(new.lon.lat$lat)
    ), epsg = 4326) |>
      sgo::sgo_lonlat_bng()
    
    new.lon.lat_ngr <- new.lon.lat_bng |>
      sgo::sgo_bng_ngr()
    
    
    # Update eastings input
    updateNumericInput(session,
                       inputId = "eastings",
                       value = as.numeric(new.lon.lat_bng$x)
    )
    
    # Update northings input
    updateNumericInput(session,
                       inputId = "northings",
                       value = as.numeric(new.lon.lat_bng$y)
    )
    
    # Update grid reference input
    updateTextInput(session,
                    inputId = "grid.ref",
                    value = new.lon.lat_ngr$ngr
    )
    
    # Update click position
    leaflet::leafletProxy("map") |>
      leaflet::clearMarkers() |>
      leaflet::addMarkers(
        lng = new.lon.lat$lon,
        lat = new.lon.lat$lat
      )
    
  }) |>
    bindEvent(input$lon.lat.update)
  
  # Update location input boxes based on eastings and northings values ---------------
  
  observe({
    
    new.bng_lon.lat <- sgo_points(list(as.numeric(input$eastings), as.numeric(input$northings)), epsg = 27700) |>
      sgo::sgo_bng_lonlat()
    
    new.bng_ngr <- sgo_points(list(as.numeric(input$eastings), as.numeric(input$northings)), epsg = 27700) |>
      sgo::sgo_bng_ngr()
    
    
    # Update latitude input
    updateNumericInput(session,
                       inputId = "lat",
                       value = as.numeric(new.bng_lon.lat$y)
    )
    
    # Update longitude input
    updateNumericInput(session,
                       inputId = "lon",
                       value = as.numeric(new.bng_lon.lat$x)
    )
    
    # Update grid reference input
    updateTextInput(session,
                    inputId = "grid.ref",
                    value = new.bng_ngr$ngr
    )
    
    # Update click position
    leaflet::leafletProxy("map") |>
      leaflet::clearMarkers() |>
      leaflet::addMarkers(
        lng = new.bng_lon.lat$x,
        lat = new.bng_lon.lat$y
      )
    
  }) |>
    bindEvent(input$e.n.update)
  

# Survey Data Table -------------------------------------------------------
  
  reactive_surveyData_df <- reactiveVal()
  
  observe({
    
    reactive_surveyData_df(surveyData_df_init)
    
  })

  output$surveyData_table <- renderRHandsontable({
    
    surveyData_df <- reactive_surveyData_df()
    
    rhandsontable::rhandsontable(surveyData_df,
                                 overflow = "visible",
                                 stretchH = "all",
                                 rowHeaders = NULL) %>%
      rhandsontable::hot_validate_numeric(cols = c("Const", "Cover"),
                                          min = 0, max = 100000000, allowInvalid = FALSE) %>%
      rhandsontable::hot_col(col = colnames(surveyData_df), halign = "htCenter") %>%
      rhandsontable::hot_col(col = c("Species"),
                             type = "dropdown",
                             source = names(species.options),
                             strict = TRUE) %>%
      htmlwidgets::onRender("
      function(el, x) {
        var hot = this.hot
        $('a[data-value=\"Survey Data\"').on('click', function(){
          setTimeout(function() {hot.render();}, 0);
        })
      }")
  })
  
  surveyData_table_filled.r <- reactive({
    rhandsontable::hot_to_r(input$surveyData_table)
  })
  
  # outputOptions(output, "surveyData_table", suspendWhenHidden = FALSE)  
  

# Create Module Data Object -----------------------------------------------

  # return()

}
