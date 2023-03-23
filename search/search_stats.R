#### Value Boxes for basic stats ####
output$comboboxes_name <- renderUI({
  if (length(search$wordcloud_element) == 0 & length(search$result_flag_name) > 0) {
    if (search$result_flag_name) {
      fluidRow(
        # column(width = 1, div()),
        column(width = 3, custom_value_box(value = search$result_stats[["total"]],
                                           subtitle = "Total Observation")),
        column(
          width = 9,
          column(
            width = 3, custom_value_box(value = search$result_stats[["distinct_kingdom"]],
                                        subtitle = "Kingdom")
          ),
          column(
            width = 3, custom_value_box(value = search$result_stats[["distinct_start"]],
                                        subtitle = "Start Date")
          ),
          column(
            width = 3, custom_value_box(value = search$result_stats[["distinct_taxon"]],
                                        subtitle = "Taxon Rank")
          ),
          column(
            width = 3, custom_value_box(value = data_value$stats$Freq[data_value$stats$Var1 == "distinct_location"],
                                        subtitle = "Distinct Locations")
          )
        ), style = "padding:1%;padding-top:2%"
      )
    } else div()
  } else div()
})


#################### Location Plot - Search Result ##########################

#### location vs count plot for search result ####
output$search_location_plot <- renderPlotly({
  data = search$result_stats$location[1:10, ]
  plot_ly(data, x = data$Var1, y = data$Freq, color = data$Var1, type = "bar") %>%
    layout(title = '',
           xaxis = list(tickvals=data$Var1, 
                        ticktext=data$Var1,
                        title = "Location",
                        showgrid = TRUE,
                        categoryarray = data$Var1,
                        categoryorder = "array"),
           yaxis = list(title = "Locations",
                        tickformat=",d",
                        showgrid = TRUE),
           showlegend = TRUE)
})


#### location vs count table for search result ####
output$search_location_dt <- renderDataTable({
  datatable(search$result_stats$location,
            colnames = c("Location", "Count"))
})

#################### Location Plot - Search Result ##########################


#################### Time Plot - Search Result ##########################

#### time vs count plot for search result ####
output$time_division_plot <- renderPlotly({
  data = search$result_stats$event_date
  plot_ly(x = data[, 1], y = data[, 2]) %>%
    add_lines(y = data[, 2]) %>%
    layout(xaxis = list(title = "Year", titlefont = "Observed in year"), 
           yaxis = list(title = "Observation(s) done ", titlefont = "Observed in year"))
})

#### time vs count table for search result ####
output$time_division_dt <- renderDataTable({
  datatable(search$result_stats$event_date,
            colnames = c("Year-Month", "Count"))
})

#################### Time Plot - Search Result ##########################