objectHash_modal <- function(search_id) {
  data = search$result %>% filter(id == search_id)
  showModal(div(
    id = "search_key_modal",
    modalDialog(
      title = popup_header(paste("Complete overview about", search_id)),
      fluidPage(
        fluidRow(box(collapsible = T, width = NULL, 
                     tags$img( src = as.character(data$access_uri, style = "width:100%") )
                     )
                 ),
        fluidRow(div(dataTableOutput("detailed_metadata_searched_key"), style = "overflow-x:auto"))
      ),
      fade = FALSE,
      easyClose = TRUE,
      footer = NULL
    )
  ))
}


observeEvent(input$object_info_popup,{
  objectHash_modal(input$object_info_popup)
})


popup_header <- function(heading){
  fluidRow(
    column(width = 8, heading),
    column(offset = 3,width = 1,  actionLink("close_modal", label = icon("times"), style = "color: black;"))
  )
}

output$detailed_metadata_searched_key <- renderDataTable({
  data = search$result %>% filter(id == input$object_info_popup)
  datatable(data, options = list(dom = "t"))
})

observeEvent(input$close_modal,{
  removeModal()
})