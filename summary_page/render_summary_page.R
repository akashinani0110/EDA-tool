############## Vernacular Name Box #################

#### Render Vernacular Name Vs Count bar plot for top 10 value ####
output$vernacular_name_plot <- renderPlotly(
  plot_ly(data_value$vernacular_name[1:10, ], labels = ~Var1, values = ~Freq, type = 'pie',
          textinfo='label+percent',
          textposition = 'inside',
          insidetextfont = list(color = '#FFFFFF'),
          marker = list(colors = c('purple','grey','darkred'),
                        line = list(color = '#FFFFFF', width = 1)),
          showlegend = TRUE)
)


#### Render Table for Vernacular Name Vs Count ####
output$vernacular_name_dt <- renderDataTable({
  datatable(data_value$vernacular_name,
            colnames = c("Vernacular Name", "Count"))
})

############## Vernacular Name Box #################


############## Scientific Name Box #################

#### Render Scientific Name Vs Count bar plot ####
output$scientific_name_plot <- renderPlotly(
  plot_ly(data_value$scientific_name[1:10, ], labels = ~Var1, values = ~Freq, type = 'pie',
          textinfo='label+percent',
          textposition = 'inside',
          insidetextfont = list(color = '#FFFFFF'),
          marker = list(colors = c('purple','grey','darkred'),
                        line = list(color = '#FFFFFF', width = 1)),
          showlegend = TRUE)
)

#### Render Table for Scientific Name Vs Count ####
output$scientific_name_dt <- renderDataTable({
  datatable(data_value$scientific_name,
            colnames = c("Scientific Name", "Count"))
})

############## Scientific Name Box #################


############## Location Box #################

#### Render Location Vs Count pie plot ####
output$location_plot <- renderPlotly({
  suppressWarnings({
    data = data_value$location[1:10, ]
    plot_ly(data, x = data$country, y = data$count, color = data$country, type = "bar") %>%
      layout(title = '',
             xaxis = list(tickvals=data$country, 
                          ticktext=data$country,
                          title = "Location",
                          showgrid = TRUE,
                          categoryarray = data$country,
                          categoryorder = "array"),
             yaxis = list(title = "Count",
                          tickformat=",d",
                          showgrid = TRUE),
             showlegend = TRUE) 
  })
})


#### Render Table for Location Vs Count ####
output$location_dt <- renderDataTable({
  datatable(data_value$location,
            colnames = c("Location", "Count"))
})

############## Location Box #################


############## Taxon Rank Box #################

#### Render Taxon Rank Vs Count pie plot ####
output$taxon_rank_plot <- renderPlotly({
    data = data_value$taxon_rank
    plot_ly(data, x = data$`taxon rank`, y = data$count, color = data$`taxon rank`, type = "bar") %>%
      layout(title = '',
             xaxis = list(tickvals=data$`taxon rank`, 
                          ticktext=data$`taxon rank`,
                          title = "Taxon Rank",
                          showgrid = TRUE,
                          categoryarray = data$`taxon rank`,
                          categoryorder = "array"),
             yaxis = list(title = "Count",
                          tickformat=",d",
                          showgrid = TRUE),
             showlegend = TRUE)
})


#### Render Table for Taxon Rank Vs Count ####
output$taxon_rank_dt <- renderDataTable({
  datatable(data_value$taxon_rank,
            colnames = c("Taxon Rank", "Count"))
})




############## Taxon Rank Box #################