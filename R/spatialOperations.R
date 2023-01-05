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


# Find centroid of polygon ------------------------------------------------

find_searchArea_centroid <- function(searchArea){
  
  centroid <- searchArea |>
    sf::st_centroid()
  
  return(centroid)
  
}
