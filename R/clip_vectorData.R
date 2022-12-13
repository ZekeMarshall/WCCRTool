# Ancient Woodlands -------------------------------------------------------

read_AWData <- function(AWPath){
  
  AWData <- sf::st_read(AWPath)
  
}

clip_AWData <- function(AWData, clipArea){
  
  AWData_clipped <- AWData |>
    sf::st_intersection(clipArea) |>
    sf::st_transform(crs = sf::st_crs(4326))
  
  return(AWData_clippedS)
  
}


# National Forest Inventory -----------------------------------------------

read_NFIData <- function(NFIPath){
  
  NFIData <- sf::st_read(NFIPath)
  
}

clip_NFIData <- function(NFIData, clipArea){
  
  NFIData_clipped <- NFIData |>
    sf::st_intersection(clipArea) |>
    sf::st_transform(crs = sf::st_crs(4326))
  
  return(NFIData_clippedS)
  
}