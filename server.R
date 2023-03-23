function(input,output,session){
  
  
  search <- reactiveValues(flag = T, result = NULL, result_flag_name = NULL)
  
  data_value <- reactiveValues(stats = NULL, vernacular_name = NULL, scientific_name = NULL, 
                               taxon_rank = NULL, location = NULL, mapping = NULL, ver_scien_mapping = NULL)
  
  eda <- reactiveValues(data = data.frame(), preview = F, data_types = NULL)
  
  data_value$ver_scien_mapping <- fread("Data/vern_scien_map.csv")
  
  data_value$stats = fromJSON('Data/distinct_stats.json')
  
  data_value$vernacular_name = fread("Data/vernacularName.csv")
  
  data_value$scientific_name = fread("Data/scientificName.csv")
  # data123 <<- data_value$scientific_name 
  
  data_value$taxon_rank = fromJSON('Data/taxonRank.json')
  
  data_value$location = fread("Data/location.csv")
  
  data_value$mapping = fromJSON('Data/mapping.json', simplifyDataFrame = F, simplifyVector = F)
  
  output$render_header <- renderUI({
    header_content()
  })
  
  output$render_body <- renderUI({
    render_body()
  })
  
  output$sidebar_menu <- renderMenu({
    sidebar_menu()
  })

  ######### Structure ################################
  source(paste0(getwd(),"/common_function.R"), local=TRUE)$value
  
  source(paste0(getwd(),"/render_sidebar_menu.R"), local=TRUE)$value
  source(paste0(getwd(),"/render_body.R"), local=TRUE)$value
  source(paste0(getwd(),"/render_header.R"), local=TRUE)$value
  
  source(paste0(getwd(),"/summary_page/define_summary_page.R"), local=TRUE)$value
  source(paste0(getwd(),"/summary_page/render_summary_page.R"), local=TRUE)$value
  
  source(paste0(getwd(),"/search/define_search.R"), local=TRUE)$value
  source(paste0(getwd(),"/search/search_visualization.R"), local=TRUE)$value
  source(paste0(getwd(),"/search/word_cloud.R"), local=TRUE)$value
  source(paste0(getwd(),"/search/search_stats.R"), local=TRUE)$value
  source(paste0(getwd(),"/search/object_popup.R"), local=TRUE)$value
  source(paste0(getwd(),"/search/render_search_name.R"), local=TRUE)$value
  
  source(paste0(getwd(),"/EDA/define_EDA.R"), local=TRUE)$value
  source(paste0(getwd(),"/EDA/render_EDA.R"), local=TRUE)$value
  
  source(paste0(getwd(),"/render_note.R"), local=TRUE)$value
 
}