get_gallery_view <- function(search_result, filter_location, ...) {
  if (filter_location != "All") {
    search_result <- search_result %>% filter(countryCode == filter_location & !is.na(access_uri))
  }
  
  # search_result = search_result
  box(
    title = NULL,
    status = "success",
    width = NULL,
    userList(lapply(search_result[["id"]], function(x) {
      tags$button(
        id = "web_button",
        class = "btn action-button",
        tags$img(
          src = search_result[search_result[["id"]] == x, c("access_uri")],
          onclick = paste0("view_object_information_functionality('", x, "')"),
          height = "145px",
          style = "width: 145px;"
        )
        ,
        style = "background: transparent;padding-right: 0%;}"
      )
    }))
  )
}


get_table_view <- function(search_result, filter_location, valid_image, ...) {
    if (valid_image) {
      search_result = search_result  %>% filter(access_uri != "")
      
      search_result <-  cbind(
        "Object" = paste0('<div class="btn-group" role="group" aria-label="Basic example">
                        <button type="button" style="height: 40px;width: 50px;background: #ccc url(',search_result$access_uri,');background-repeat: round;" class="btn btn-secondary download"  
                        onclick=view_object_information_',"functionality",'(\'', search_result$id, '\')></button> </div>' ),
        search_result
      )
      
      if (nrow(search_result) > 0) {
        search_result = search_result %>% select(c("Object","taxonRank", "higherClassification",
                                                   "longitudeDecimal", "latitudeDecimal", "countryCode", "eventDate"))
      }
    } else {
      if (nrow(search_result) > 0) {
        search_result = search_result %>% select(c("taxonRank", "higherClassification", "longitudeDecimal",
                                                   "latitudeDecimal", "countryCode", "eventDate", "access_uri"))
      }
    }
  
  if (filter_location != "All") {
          search_result <- search_result %>% filter(countryCode == filter_location)
      } 
  
  DT::datatable(data = search_result,
                escape = FALSE,
                selection = "multiple",
                rownames = rownames(search_result),
                colnames = gsub("\\.", " ", colnames(search_result)),
                options = list(
                  columnDefs = list(list(
                    className = 'dt-center', targets = 0:(length(colnames(search_result)) - 1)
                  )),
                  pageLength = 10,
                  searching = FALSE,
                  ordering = TRUE,
                  server = FALSE
                  # dom = 't'
                ),
                class = "display")
  
}


get_map_view <- function(search_result, filter_location, ...) {
  if (filter_location != "All") {
    data <- search_result %>% filter(countryCode == filter_location)
  }
  
  data <- data %>% select(c("id","access_uri", "latitudeDecimal", "longitudeDecimal"))
  
  latitude = data$latitudeDecimal
  longitude = data$longitudeDecimal
  object_identity = data$id
  link <- data$access_uri
  
  leaflet() %>%
    addTiles() %>%
    # addProviderTiles(providers$Esri.WorldStreetMap,
    #                  group = "WorldStreetMap",
    #                  options = providerTileOptions(minZoom = 1, maxZoom = 29)
    #                  ) 
    addMiniMap(zoomAnimation = T,
               # tiles = providers$Esri,
               width = 150,
               height = 150,
               zoomLevelOffset = -6,
               autoToggleDisplay = T
               ) %>%
    addMarkers(lat = as.numeric(latitude),
               lng = as.numeric(longitude),
               clusterOptions = markerClusterOptions(),
               clusterId = "quakesCluster",
               icon = icons(iconUrl =  "marker.png",
                            iconWidth = 43,
                            iconHeight = 44),
               popup = paste0("<img style = 'width:70px;height:70px;' onclick = view_object_information_functionality('",
                              object_identity, "') src = ", link, ">" )
               ) %>%
    addFullscreenControl(position = "topleft", pseudoFullscreen = TRUE)
}


