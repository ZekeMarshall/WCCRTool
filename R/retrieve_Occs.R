# Create search area ------------------------------------------------------

create_searchAreaPolygon <- function(polygon, colonisationRate, colonisationYears){
  
  searchArea <- sf::st_buffer(polygon, 
                              dist = colonisationRate * colonisationYears, 
                              joinStyle = "ROUND")
  
  return(searchArea)
  
  
}

create_searchAreaPoint <- function(lng, lat, colonisationRate, colonisationYears){
  
  location <- sf::st_as_sf(data.frame("lng" = lng, 
                                      "lat" = lat), 
                           coords = c("lng", "lat"), 
                           crs = sf::st_crs(4326), 
                           dim = "XY")
  searchArea <- sf::st_buffer(location, dist = colonisationRate * colonisationYears)
  
  return(searchArea)
  
  
}

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
  raw.result <- httr::GET(url = "https://records-ws.nbnatlas.org/occurrence/facets?",
                          # httr::verbose(),
                          query = list("q"= species,
                                       "facets" = "taxon_name,latitude,longitude",
                                       "wkt" = searchArea_rectangle_wkt)
  )
  
  # Unpack API response
  raw.result.content <- httr::content(raw.result)
  
  if (length(raw.result.content) == 0) {
    
    occs_df <- tibble::tribble(~lng, ~lat)
    
  } else {
    
    # https://www.r-bloggers.com/2018/10/converting-nested-json-to-a-tidy-data-frame-with-r/
    # raw.result.content_df <- tibble::enframe(unlist(raw.result.content))
    
    raw.result.content_nested_df <- jsonlite::fromJSON(base::rawToChar(raw.result$content))
    
    raw.result.content_df <- data.frame(
      lng = raw.result.content_nested_df$fieldResult[[3]]$label, 
      lat = raw.result.content_nested_df$fieldResult[[2]]$label
    )
    
    # Convert to sf list of points
    occs_sf <- raw.result.content_df |>
      sf::st_as_sf(coords = c("lng", "lat"), 
                   crs = sf::st_crs(4326), 
                   dim = "XY") #|>
      #sf::st_transform(crs = sf::st_crs(3857))
    
    # searchArea_3857 <- searchArea |>
    #   sf::st_transform(crs = sf::st_crs(3857))
    
    # Filter SF point occurrences
    occs_sf_cropped <- occs_sf #|>
     # sf::st_intersection(searchArea)
    
    # Convert to data frame
    occs_df <- occs_sf_cropped |> 
      sf::st_coordinates() |>
      as.data.frame() |>
      dplyr::rename("lng" = "X", "lat" = "Y")
    
  }
  
  return(occs_df)
  
}




