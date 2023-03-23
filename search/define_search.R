output$render_search_name <- renderUI({
  div(id = "page_outlook",
    fluidRow(
      #### create search _box for scientific name  ####
      column(width = 3, 
             searchInput(
               inputId = "scientific",
               label = NULL,
               placeholder = "Search By Scientific Name",
               btnReset = icon("remove"),
               btnSearch = icon("search"),
               width = "100%"
             )
      ),
      column(width = 1, div()),
      #### create search _box for vernacular name ####
      column(width = 3, 
             searchInput(
               inputId = "vernacular",
               label = NULL,
               placeholder = "Search By Vernacular Name",
               btnReset = icon("remove"),
               btnSearch = icon("search"),
               width = "100%"
             )
      ),
      column(width = 1, div() ),
      
      #### Selection of view incase of search result ####
      column(width = 4, uiOutput("select_tab_format"))
    ),
    
    fluidRow(
    #### create actionlink to get wordcloud for Scientific Name ####
      column(width = 3,
             actionLink(label = "Select scientific Name from Word-cloud",
                        inputId = "wordcloud_scientific",
                        ),
             style = "margin-top:-1%"
             ),
      column(width = 1, div()),
    #### create actionlink to get wordcloud for Vernacular Name ####
      column(width = 3,
             actionLink(label = "Select Vernacular Name from word-cloud",
                        inputId = "wordcloud_vernaciular"),
                        style = "margin-top:-1%"
             )
      ),
    
    #### create value boxes for search result ####
    fluidRow(uiOutput("comboboxes_name")),
    
    #### Get word cloud for scientific name or vernacular name based on link ####
    fluidRow(uiOutput("get_wordcloud_ui"), style = "padding:2%"),
    
    #### Get Boxes for visualization for location and time division ####
    fluidRow(uiOutput("get_result_name"), style = "padding:2%; margin-top:-5%"),
    
    #### Filters to subset search result ####
    fluidRow(uiOutput("filter")),
    
    #### Table/Gallery/Map visualization for search result ####
    fluidRow(uiOutput("search_result_view"))
    )
})