# Retrieve GBIF occurrences for a single species --------------------------

retrieve_GBIFOccurrences <- function(species, searchArea){
  
  searchArea_wkt <- sf::st_as_text(searchArea$geometry)

  key <- rgbif::name_backbone(name = species, kingdom = 'plants')
  
  response <- rgbif::occ_search(taxonKey = as.numeric(key$usageKey), limit = 99999,
                                geometry = searchArea_wkt)
  
  occ_df <- data.frame(id = response$data$key,
                       lat = response$data$decimalLatitude, 
                       lon = response$data$decimalLongitude) |>
    dplyr::filter(!is.na(lat) | !is.na(lon))
  
  return(occ_df)
  
}


# Retrieve NBN Atlas Occurrences ------------------------------------------

retrieve_NBNOccurrences <- function(species, searchArea){
  
  # m = rbind(c(0,0), c(1,0), c(1,1), c(0,1), c(0,0))
  # p = st_polygon(list(m))
  
  # Create simple rectangle around polygon to reduce length of WKT
  searchArea_bbox <- sf::st_bbox(searchArea)
  bbox_df <- tibble::tribble(
    ~corner, ~x, ~y,
    "bottomleft", as.numeric(searchArea_bbox$xmin), as.numeric(searchArea_bbox$ymin),
    "bottomright", as.numeric(searchArea_bbox$xmax), as.numeric(searchArea_bbox$ymin),
    "topright", as.numeric(searchArea_bbox$xmax), as.numeric(searchArea_bbox$ymax),
    "topleft", as.numeric(searchArea_bbox$xmin), as.numeric(searchArea_bbox$ymax)
  )
  
  searchArea_rectangle <- sfheaders::sf_polygon(obj = bbox_df,
                                                x = "x",
                                                y = "y") |>
    sf::st_set_crs(sf::st_crs(4326))
  
  searchArea_rectangle_wkt <- sf::st_as_text(searchArea_rectangle$geometry)
  
  # Make API call
  response <- httr::GET(url = "https://records-ws.nbnatlas.org/occurrence/facets?",
                        # httr::verbose(),
                        query = list("q"= species,
                                     "facets" = "taxon_name,latitude,longitude", #,coordinatePrecision,dateIdentified",
                                     "wkt" = searchArea_rectangle_wkt)
  )
  
  # Unpack API response
  response.content <- httr::content(response)
  
  if (length(response.content) == 0) {
    
    response_df <- tibble::tribble(~lng, ~lat)
    
  } else {
    
    response.content_nested <- jsonify::to_json(response.content, unbox = T) |>
      jsonlite::fromJSON() |>
      dplyr::select(-count) |>
      tidyr::pivot_wider(names_from = fieldName,
                         values_from = fieldResult)
    
    response.latitude <- response.content_nested$latitude[[1]] |>
      dplyr::pull(label)
    
    response.longitude <- response.content_nested$longitude[[1]] |>
      dplyr::pull(label)
    
    response_df <- data.frame("lng" = response.longitude,
                              "lat" = response.latitude)
    
      
    
    # response.content_nested <- jsonlite::fromJSON(base::rawToChar(response$content))
    # raw.result.content_df <- data.frame(
    #   # dateIdentified = raw.result.content_nested_df$fieldResult[[5]]$label,
    #   # coordinatePrecision = raw.result.content_nested_df$fieldResult[[4]]$label,
    #   lng = raw.result.content_nested_df$fieldResult[[3]]$label, 
    #   lat = raw.result.content_nested_df$fieldResult[[2]]$label
    # )
    
    # Convert to sf list of points
    occs_sf <- response_df |>
      sf::st_as_sf(coords = c("lng", "lat"), 
                   crs = sf::st_crs(4326), 
                   dim = "XY") 
    
    # Filter SF point occurrences
    occs_sf_cropped <- occs_sf #|>
     #sf::st_intersection(searchArea)
    
    
  }
  
  return(occs_sf)
  
}




