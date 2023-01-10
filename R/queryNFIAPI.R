
queryNFIAPI <- function(lonleft, lonright, latbot, lattop){
  
  nfi_api_url <- "https://services2.arcgis.com/mHXjwgl3OARRqqD4/arcgis/rest/services/Nationa_Forest_Inventory_Woodland_GB_2020/FeatureServer/0/query?"
  
  query_url <- paste0("where=", "1%3D1", "&",
                      "outFields=", "*", "&",
                      "geometry=", lonleft, "%2C", latbot, "%2C", lonright, "%2C", lattop, "&",
                      "geometryType=", "esriGeometryEnvelope", "&",
                      "inSR=", "4326", "&",
                      "spatialRel=", "esriSpatialRelIntersects", "&",
                      "outSR=", "4326", "&",
                      "f=", "json")
  
  response <- httr::GET(url = paste0(nfi_api_url, query_url))
  
  response.content <- httr::content(response)
  
  response_json <- jsonify::to_json(response.content, unbox = T)
  
  response_sf <- sf::st_read(response_json, quiet = TRUE)
  
  return(response_sf)
  
  
}