output$render_summary <- renderUI({
  div(id = "page_outlook",
      #### Create value boxes for Stats over full data set ####
    fluidRow(id = "cobo_box_summary",
      column(width = 3,
             custom_value_box(subtitle = "Total Observation",
                              value = data_value$stats$Freq[data_value$stats$Var1 == "total_observation"])
      ),
      column(width = 9,
             column(width = 3,
                    custom_value_box(subtitle = "Distinct Taxon Rank",
                                     value = data_value$stats$Freq[data_value$stats$Var1 == "distinct_taxon_rank"])
             ),
             column(width = 3,
                    custom_value_box(subtitle = "Distinct Vernacular Name",
                                     value = data_value$stats$Freq[data_value$stats$Var1 == "distinct_vernacularName"])
             ),
             column(width = 3,
                    custom_value_box(subtitle = "Distinct Scientific Name",
                                     value = data_value$stats$Freq[data_value$stats$Var1 == "distinct_scientificName"])
             ),
             column(width = 3,
                    custom_value_box(subtitle = "Distinct Locations",
                                     value = data_value$stats$Freq[data_value$stats$Var1 == "distinct_location"])
             )
      )
    ),
    #### create boxes for plot and table ####
    fluidRow(
      tabset_box_output(id = "location", label = "Location"),
      tabset_box_output(id = "taxon_rank", label = "Taxon Rank")
    ),
    fluidRow(
      tabset_box_output(id = "scientific_name", label = "Scientific Name"),
      tabset_box_output(id = "vernacular_name", label = "Vernacular Name")
    )
  )
})


##############################
output$eda_tool <- renderUI({
  div(id = "page_outlook",
      fluidRow(fileInput("file", "Upload CSV file")),
      uiOutput("get_preview"),
      uiOutput("view_options"),
      uiOutput("get_result_eda")
  )
})



observeEvent(input$file, {
  eda$data = read.csv(input$file$datapath)
  eda$preview = F
})


output$get_preview <- renderUI({
  if (!eda$preview & nrow(eda$data) > 0) {
    div(
      fluidRow(column(width = 4, uiOutput("input_types")),
               column(width = 8, tableOutput("data_preview"))),
      fluidRow(actionButton(label = "submit", inputId = "submit_preview"))
    )
    } else div()
})

output$data_preview <- renderTable({
  head(eda$data)
})

output$input_types <- renderUI({
  df <- eda$data
  types <- sapply(df, class)
  inputs <- lapply(names(df), function(x) {
    selectInput(paste0("type_", x), x, unique(c(class(x), "character", "numeric", "POSIXct", "boolean")))
  })
  do.call(tagList, inputs)
})

observeEvent(input$submit_preview, {
  eda$preview = T
  data_types <- lapply(names(eda$data), function(x) {
    input[[paste0("type_", x)]]
  })
  eda$data_types = unlist(data_types)
  eda$data = read.csv(input$file$datapath, colClasses = eda$data_types)
})


output$view_options <- renderUI ({
  if (eda$preview)  {
    fluidRow(column(width = 6, radioButtons(
      inputId = "options",
      label = NULL,
      choices = c("Structure", "Classes", "Summary", "Analysis"),
      selected = NULL,
      inline = T
    )), 
    column(width = 3, offset = 3, uiOutput("select_bivariate")))
  }
})

output$get_result_eda <- renderUI({
  if(eda$preview & length(input$options) != 0)
    if (input$options %in% c("Structure", "Classes", "Summary"))  {
      div(
        #### Create value boxes for Stats over full data set ####
        fluidRow(id = "cobo_box_summary",
                 column(width = 3,
                        custom_value_box(subtitle = "Total Records",
                                         value = nrow(eda$data))),
                 column(width = 3,
                        custom_value_box(subtitle = "Total Columns",
                                         value = length(eda$data_types))),
                 column(width = 3,
                        custom_value_box(subtitle = "Distinct Classes",
                                         value = length(unique(eda$data_types)))),
                 column(width = 3,
                        custom_value_box(subtitle = "File Size",
                                         value = round(input$file$size/100000)))
        ),
        fluidRow(uiOutput("display_structure")),
        #### create boxes for plot and table ####
        fluidRow(DT::dataTableOutput("data"), style = "padding:1%")
      )
    } else if (input$options == "Analysis") {
      uiOutput("get_analytics")
    } else div()
})


output$display_structure <- renderUI({
  if (input$options %in% "Summary") {
    verbatimTextOutput("summary")
  } else if (input$options %in% "Structure") {
    verbatimTextOutput("structure")
  } else {
    verbatimTextOutput("classes")
  }
})


output$data <- DT::renderDataTable({
  eda$data
})

output$summary <- renderPrint({
  summary(eda$data)
})

output$structure <- renderPrint({
  str(eda$data)
})

output$classes <- renderPrint({
  sapply(eda$data, class)
})


output$select_bivariate <- renderUI({
  if(eda$preview & length(input$options) != 0)
    if(input$options == "Analysis") {
      checkboxInput(inputId = "bivariate_distribution",
                    value = F, 
                    label = "Bivariate Distribution")
    }
})


output$get_analytics <- renderUI({
  if (nrow(eda$data) != 0)  {
    div(
      fluidRow(
        column(width = 3,
               pickerInput(inputId = "univariate",
                           label = "Select Attribute",
                           choices = colnames(eda$data),
                           selected = "",
                           multiple = TRUE,
                           width = 300,
                           options = list(
                             `live-search` = TRUE,
                             "max-options" = 1,
                             "max-options-text" = "No more!",
                             dropdownAlignRight = TRUE,
                             size = 10,
                             title = "Select",
                             `selected-text-format` = "count > 4"
                           ))
        ), column(width = 3, offset = 2,
                  uiOutput("bivariate_attribute"))
      ),
      fluidRow(uiOutput("select_type")),
      fluidRow(plotlyOutput("create_chart"))
    )
}
  
})

output$bivariate_attribute <- renderUI({
  if (input$bivariate_distribution)
    pickerInput(inputId = "bivariate",
                label = "Select Attribute",
                choices = colnames(eda$data),
                selected = "",
                multiple = TRUE,
                width = 300,
                options = list(
                  `live-search` = TRUE,
                  "max-options" = 1,
                  "max-options-text" = "No more!",
                  dropdownAlignRight = TRUE,
                  size = 10,
                  title = "Select",
                  `selected-text-format` = "count > 4"
                ))
})



