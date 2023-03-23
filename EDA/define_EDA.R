output$eda_tool <- renderUI({
  div(id = "page_outlook",
      fluidRow(fileInput("file", "Upload CSV file", accept = c(".csv"))),
      uiOutput("get_preview"),
      uiOutput("view_options"),
      uiOutput("get_result_eda")
  , style = "padding:1%;")
})

output$get_preview <- renderUI({
  if (!eda$preview & nrow(eda$data) > 0) {
    div(
      fluidRow(column(width = 4, uiOutput("input_types") ),
               column(width = 8,  tableOutput("data_preview"), style= "overflow-y:auto" )
      ),
      fluidRow(actionButton(label = "submit", 
                            inputId = "submit_preview",
                            style = "margin-left:10%; font-weight: bold;")),
      style = "background:white; border-radius:22px; padding:1%; border:black;border:solid")
  } else div()
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
        fluidRow(DT::dataTableOutput("data"), style = "padding:1%;overflow-y:auto;;background:white; ")
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
      fluidRow(plotlyOutput("create_chart"), style = "padding:1%")
    , style = "padding:1%;")
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
