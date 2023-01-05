# Ancient Woodlands -------------------------------------------------------

read_AWData <- function(AWPath){
  
  AWData <- sf::st_read(AWPath)
  
}

clip_AWData <- function(AWData, clipArea){
  
  AWData_clipped <- AWData |>
    sf::st_intersection(clipArea) |>
    sf::st_transform(crs = sf::st_crs(4326))
  
  return(AWData_clipped)
  
}


# National Forest Inventory -----------------------------------------------

read_NFIData <- function(NFIPath){
  
  NFIData <- sf::st_read(NFIPath)
  
  return(NFIData)
  
}

clip_NFIData <- function(NFIData, clipArea){
  
  NFIData_clipped <- NFIData |>
    sf::st_intersection(clipArea) |>
    sf::st_transform(crs = sf::st_crs(4326))
  
  return(NFIData_clipped)
  
}


# Roads -------------------------------------------------------------------

read_roadsData <- function(roadsPath){
  
  roadsData <- sf::st_read(roadsPath)
  
  return(roadsData)
  
}

clip_roadsData <- function(roadsData, clipArea){
  
  roadsData_clipped <- roadsData |>
    sf::st_intersection(clipArea) |>
    sf::st_transform(crs = sf::st_crs(4326))
  
  return(roadsData_clipped)
  
}


# Railways ----------------------------------------------------------------

read_railwaysData <- function(railwaysPath){
  
  railwaysData <- sf::st_read(railwaysPath) |>
    dplyr::filter(ELR == "ECM5")
  
  return(railwaysData)
  
}

clip_railwaysData <- function(railwaysData, clipArea){
  
  railwaysData_clipped <- railwaysData |>
    sf::st_intersection(clipArea) |>
    sf::st_transform(crs = sf::st_crs(4326))
  
  return(railwaysData_clipped)
  
}


# Rivers ------------------------------------------------------------------

read_riversData <- function(riversPath){
  
  riversData <- sf::st_read(riversPath)
  
  return(riversData)
  
}

clip_riversData <- function(riversData, clipArea){
  
  riversData_clipped <- riversData |>
    sf::st_intersection(clipArea) |>
    sf::st_transform(crs = sf::st_crs(4326))
  
  return(riversData_clipped)
  
}


# Urban Areas -------------------------------------------------------------

read_urbanAreasData <- function(urbanAreasPath){
  
  urbanAreasData <- sf::st_read(urbanAreasPath)
  
  return(urbanAreasData)
  
}

clip_urbanAreasData <- function(urbanAreasData, clipArea){
  
  urbanAreasData_clipped <- urbanAreasData |>
    sf::st_intersection(clipArea) |>
    sf::st_transform(crs = sf::st_crs(4326))
  
  return(urbanAreasData_clipped)
  
}


# Woody linear features ---------------------------------------------------








