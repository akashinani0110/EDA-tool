#### Reset the value for scientific name search box in case of clicking X" ####
observeEvent(input$scientific_reset,{
  updateSelectInput(session, inputId = "scientific",
                    label = NULL, selected = "")
})


#### Reset the value for vernacular name search box in case of clicking X" ####
observeEvent(input$vernacular_reset,{
  updateSelectInput(session, inputId = "vernacular",
                    label = NULL, selected = "")
})


#### On click of search by vernacular name ####
observeEvent(input$vernacular_search, {
  search$result_flag_name = F
  search$wordcloud_element = NULL
  search$result_flag_name = T
  
  # Get vernacular name
  ver_name = input$vernacular
  
  # Store vernacular name to reactive variable
  search$vernacular_name = ver_name
  
  # Get corresponding Scientific name for the vernacular name
  name = data_value$ver_scien_mapping %>% 
    filter(vernacularName == ver_name) %>% 
    select(scientificName)
  print(name)
  # Incase no scientific name is found set it to "Not Found"
  if (nrow(name) == 0) name = "Not Found" else name = as.character(name)
  
  # Store scientific name to reactive variable
  search$scientific_name = name
  
  # update corresponding scientific name search box
  updateSelectInput(session, inputId = "scientific", label = NULL, selected = name)
})


#### On click of search by Scientific Name ####
observeEvent(input$scientific_search, {
  search$result_flag_name = F
  search$wordcloud_element = NULL
  search$result_flag_name = T
  
  # Get scientific name
  name = input$scientific
  
  # Store scientific name
  search$scientific_name = name
  
  # Get corresponding vernacular name for the scientific name
  ver_name = data_value$ver_scien_mapping %>% filter(scientificName == name)
  print(ver_name)
  # if (is.na(ver_name)) ver_name = "Not Found" else ver_name = as.character(ver_name)
  if (nrow(ver_name) > 0 ) {
    ver_name = ver_name %>% select(vernacularName)
    ver_name = ver_name[1]
  } else ver_name = "Not Found"
  
  # Store vernacular name
  search$vernacular_name = ver_name
  
  # update corresponding vernacular name search box
  updateSelectInput(session, inputId = "vernacular", label = NULL, selected = ver_name)
})


# #### Get result for searched element ####
observeEvent(search$result_flag_name, {
  file = NULL
  name = search$scientific_name
  if (search$result_flag_name) {

    # check for the file number scientific name exists
    file = grep(name, data_value$mapping, fixed = T)[1]

    # Incase no file found for the scientific name display error else get full result set
    if (is.na(file) ) {
      search$result_flag_name = F
      return(shinyalert(title = "No Data Found", 
                        text = "Please try with some other value(s)", 
                        type = "warning"))
    } else {
      # Read the csv file where scientific name exist
      result = fread(file = paste0("Data/occurence_",file,".csv"), nThread = 4)
      
      # Get result only for scientific name searched
      result = result %>% filter(scientificName == name)

      if (nrow(result) > 0) {
        #convert country code to country name
        result$countryCode = countrycode(result$countryCode, "iso2c", "country.name")

        # Store result into reactive variable
        search$result = result
        # Get required statis about the result and
        search$result_stats <- get_data_info(result)
      } else {
        search$result_flag_name = F
        return(shinyalert(title = "No Data Found",
                          text = "Please try with some other value(s)",
                          type = "warning"))
      }
    }
  }
  
})


#### Get Analysis for Location and Time for the search result ####
output$get_result_name <- renderUI({
  if (length(search$wordcloud_element) == 0 & length(search$result_flag_name) > 0) {
    if (search$result_flag_name) {
      fluidRow(
        tabset_box_output(id = "search_location", label = "Location"),
        tabset_box_output(id = "time_division", label = "Time Division")
      )
    } else div()
  } else div()
})


#### Radio boxes for Different views to visualize search result ####
output$select_tab_format <- renderUI({
  if (length(search$wordcloud_element) == 0 & length(search$result_flag_name) > 0) {
    if (search$result_flag_name) {
      div(
        radioGroupButtons(inputId = "serach_view_input", 
                          label = NULL,
                          choices = c("Table View", "Gallery View", "Map View"),
                          individual = TRUE, 
                          checkIcon = list(yes = tags$i(class = "fa fa-circle", 
                                                        style = "color:#9bcc9c "), 
                                           no = tags$i(class = "fa fa-circle-o", 
                                                       style = "color: steelblue"))
        ),
        style = "text-align: center;" )
    }
  }
})


#### Filter(s) for result visualiztion ####
output$filter <- renderUI({
  if (length(search$wordcloud_element) == 0 & length(search$result_flag_name) > 0) {
    if (search$result_flag_name) {
      
      fluidRow(
        # Filters based on different visualiztions
        column(width = 7, uiOutput("extra_filters")),
        
        # Common filter based on country
        column(width = 2, div("Filter By Country:",
                              style = "font-weight:bold; float:right; padding-top: 3%;")),
        column(width = 2,
               selectInput(inputId = "search_location",
                           label = NULL,
                           choices = c(
                             c(as.character(search$result_stats$location$Var1[2:length(search$result_stats$location$Var1)]),
                               as.character(search$result_stats$location$Var1[1])), "All")
                             ) )
      )
    } else div()
  } else div()
})


#### Specific filters based on different visualuiztion ####
output$extra_filters <- renderUI({
  if (length(input$serach_view_input) == 0) {
    div()
  } else if (input$serach_view_input == "Table View") {
    
    # To get only observation with available images or full dataset ####
    fluidRow( 
      column(width = 1, div()),
      column(width = 8,
             materialSwitch(inputId = "only_image",
                            label = "Object(s) with available image:", value = TRUE,
                            status = "success") )
    )
  } else if (input$serach_view_input == "Gallery View") {
    
    # info - only objects for which image is available will be displayed
    fluidRow(column(width = 2, div()),
             column(width = 6, "Only object(s) with available image",
                    style = "font-weight:bold;font-size:20px")
    )
  } else div()
})


#### Render different visualizations ####
output$search_result_view <- renderUI({
  if (length(search$wordcloud_element) == 0 & length(search$result_flag_name) > 0) {
    if (search$result_flag_name) {
      if (length(input$serach_view_input) == 0) {
        div()
      } else if (input$serach_view_input == "Table View") {
        div(dataTableOutput("full_result"), style = "overflow-x:auto;padding:2%; padding-top:0%" )
      } else if (input$serach_view_input == "Gallery View") {
        div( fluidRow(uiOutput("gallery_full_result")) , style = "padding:2%; padding-top:0%")
      } else if (input$serach_view_input == "Map View") {
        div( leafletOutput( outputId = "map", width = "100%", height = 600 ) ,style =  "padding:2%;padding-top:0")
      } else div()
    }
  }
})


#### Gallery View - Call function to get images based on location ####
output$gallery_full_result <- renderUI({
  get_gallery_view(search$result, input$search_location)
})


#### Map View - Call function to get markers based on location ####
output$map <- renderLeaflet({
  get_map_view(search$result, input$search_location)
})

#### Table View - Call function to get table view based on location and available images ####
output$full_result <- renderDataTable({
  get_table_view(search$result, input$search_location, input$only_image)
})
