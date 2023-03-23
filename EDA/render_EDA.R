
observeEvent(input$file, {
  file_type <- tools::file_ext(input$file$name)
  if (file_type != "csv") {
    showModal(modalDialog(
      title = "Invalid file type",
      "Please upload a CSV file",
      easyClose = TRUE,
      footer = NULL
    ))
    eda$data = data.frame()
    eda$preview = F
  } else {
    eda$data = read.csv(input$file$datapath)
    eda$preview = F
  }
  
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



output$select_type <- renderUI({
  chart_type = NULL
  if (input$bivariate_distribution) {
    if (length(input$univariate) != 0 & length(input$bivariate) != 0) {
      type = class(eda$data[[input$univariate]])
      type2 = class(eda$data[[input$bivariate]])
      if (type[1] == "character") {
        if (type2[1] %in% c("character", "boolean")) {
          chart_type = c("Doughnut chart", "Stack bar chart", "Grouped bar chart")
        } else if (type2[1] == "numeric") {
          chart_type = c("Buble chart", "Grouped bar chart")
        } else if (type2[1] %in% c("date", "POSIXct", "POSIXlt")) {
          chart_type = c("line chart", "bar chart")
        } 
      } else if (type[1] == "numeric") {
        if (type2[1] == "numeric") {
          chart_type = c("density chart")
      }
      }
    } 
  } else {
    if (length(input$univariate) != 0 ) {
      type = class(eda$data[[input$univariate]])
      print(type[1])
      if (!input$bivariate_distribution) {
        if (type[1] %in% c("character", "boolean")) {
          chart_type = c("pie", "bar")
        } else if (type[1] == "numeric") {
          chart_type = c("density-histogram")
        } else if (type[1] == "POSIXct") {
          chart_type = c("trend", "bar")
        } 
      }
    }
  }
  if (!is.null(chart_type)) {
    radioButtons(inputId = "chart_type",
                 label = NULL,
                 choices = chart_type,
                 inline = T)
  } else div()
  
  
})


############################################################################
output$create_chart <- renderPlotly({
  if (length(input$univariate) != 0 & length(input$chart_type != 0)) {
    data = eda$data
    data1234 <<- data
    if (input$chart_type == "bar") {
      counts <<- as.data.frame(table(data[[input$univariate]]))
      colnames(counts) = c("category", "count")
      data <- counts[order(counts$count, decreasing = TRUE),]
      
      plot_ly(
        data,
        x = data$category,
        y = data$count,
        color = data$category,
        type = "bar"
      ) %>%
        layout(
          title = '',
          xaxis = list(
            tickvals = data$category,
            ticktext = data$category,
            title = input$univariate,
            showgrid = TRUE,
            categoryarray = data$category,
            categoryorder = "array"
          ),
          margin = list(b = 190),
          yaxis = list(
            title = "Count of Objects",
            tickformat = ",d",
            showgrid = TRUE
          ),
          showlegend = TRUE
        )
      
    } else if (input$chart_type == "pie") {
      counts <<- as.data.frame(table(data[[input$univariate]]))
      colnames(counts) = c("category", "count")
      counts <- counts[order(counts$count, decreasing = TRUE),]
      
      colors <- c('purple','grey','darkred')
      
      plot_ly(counts, labels = ~category, values = ~count, type = 'pie',
              textinfo='label+percent',
              textposition = 'inside',
              insidetextfont = list(color = '#FFFFFF'),
              marker = list(colors = colors,
                            line = list(color = '#FFFFFF', width = 1)),
              showlegend = TRUE) %>%
        layout(title = '',
               xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
               yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
      
    } else if (input$chart_type == "density-histogram") {
      
      plot_ly(x = data[[input$univariate]], type = "histogram", histnorm = "density") %>%
        layout(title = "Density Plot")
      
    } else if (input$chart_type == "trend") {
      # aggregate data by date
      agg_data <-
        aggregate(list(count = data[[input$univariate]]),
                  by = list(date = eda$data[[input$univariate]]),
                  FUN = length)
      
      
      # create trend chart
      plot_ly(
        data = agg_data,
        x = ~ date,
        y = ~ count,
        type = "scatter",
        mode = "lines"
      ) 
    } else if (input$chart_type == "Stack bar chart") {
      
      the_data <- aggregate(list(count = data[[input$univariate]]), 
                            by = list(key = data[[input$univariate]], 
                                      category = data[[input$bivariate]]),
                            length)
      
      plot_ly(
        the_data,
        x = the_data$category,
        y = the_data$count,
        color = the_data$key,
        colors = "Set1"
      ) %>% layout(
        title = '',
        barmode = 'stack',
        xaxis = list(
          title = input$univariate,
          tickformat = ",d",
          showgrid = TRUE
        ),
        yaxis = list(
          title = "Count of Objects",
          tickformat = ",d",
          showgrid = TRUE
        ),
        showlegend = TRUE
      )
      
    }  else if (input$chart_type == "Grouped bar chart") {
      
      the_data <- aggregate(list(count = data[[input$univariate]]), 
                            by = list(key = data[[input$univariate]], 
                                      category = data[[input$bivariate]]),
                            length)
      
      
      plot_ly(
        the_data,
        x = the_data$category,
        y = the_data$count,
        color = the_data$key,
        colors = "Set1"
      ) %>% layout(
        title = input$univariate,
        xaxis = list(
          title = "",
          tickformat = ",d",
          showgrid = TRUE
        ),
        yaxis = list(
          title = "Count of Objects",
          tickformat = ",d",
          showgrid = TRUE
        ),
        showlegend = TRUE
      )
      
    } else if (input$chart_type == "Doughnut chart") {
      # group by two columns and find count
      the_data <- aggregate(list(count = data[[input$univariate]]), 
                            by = list(key = data[[input$univariate]], 
                                      category = data[[input$bivariate]]),
                            length)
      
      plot_ly(the_data) %>%
        add_pie(
          labels = ~ key,
          values = ~ count,
          type = 'pie',
          hole = 0.7,
          sort = F,
          textinfo = 'label+percent',
          textposition = 'inside'
        ) %>%
        add_pie(
          the_data,
          labels = ~ category,
          values = ~ count,
          hole = 0.7,
          domain = list(x = c(0.15, 0.85),
                        y = c(0.15, 0.85)),
          textinfo = 'label+percent',
          sort = F
        )
      
    } else if (input$chart_type == "Buble chart" ) {
      the_data = aggregate(list(count = data[[input$univariate]]), 
                           by = list(key = data[[input$univariate]], 
                                     category = data[[input$bivariate]]),
                           length)
      
      data111 = the_data
      
      plot_ly(
        the_data,
        x = the_data$category,
        y = the_data$count,
        text = the_data$count,
        type = 'scatter',
        mode = 'markers',
        size = the_data$count,
        color = the_data$key,
        colors = 'Paired',
        marker = list(opacity = 0.5, sizemode = 'diameter')
      )  %>% layout(
        title = '',
        xaxis = list(
          title = input$bivariate,
          tickformat = ",d",
          showgrid = TRUE
        ),
        yaxis = list(
          title = "Count of Objects",
          tickformat = ",d",
          showgrid = TRUE
        ),
        showlegend = TRUE
      )
    } else if (input$chart_type == "Buble chart" ) {
      the_data = aggregate(list(count = data[[input$univariate]]), 
                           by = list(key = data[[input$univariate]], 
                                     category = data[[input$bivariate]]),
                           length)
      
      plot_ly(
        the_data,
        x = the_data$category,
        y = the_data$count,
        text = the_data$count,
        type = 'scatter',
        mode = 'markers',
        size = the_data$count,
        color = the_data$key,
        colors = 'Paired',
        marker = list(opacity = 0.5, sizemode = 'diameter')
      )  %>% layout(
        title = '',
        xaxis = list(
          title = input$bivariate,
          tickformat = ",d",
          showgrid = TRUE
        ),
        yaxis = list(
          title = "Count of Objects",
          tickformat = ",d",
          showgrid = TRUE
        ),
        showlegend = TRUE
      )
    } else if (input$chart_type == "line chart" ) {
      the_data = aggregate(list(count = data[[input$bivariate]]), 
                           by = list(category = data[[input$univariate]], 
                                     key = data[[input$bivariate]]),
                           length)
      
      the_data$timeframe <- as.Date(the_data$key,format="%Y-%m-%d")
      the_data$Month_Yr <- format(as.Date(the_data$timeframe), "%Y-%m")
      the_data$MonthYear <- as.yearmon(the_data$Month_Yr, "%Y-%m") # Only For Line Chart
      #Group By and Agrregation by MonthYear and Category
      MonthlyAggData <- aggregate(the_data$count, 
                                  by=list(Timeframe=the_data$MonthYear
                                          ,Category=the_data$category), FUN=sum)
      # MonthlyAggData$count<- prettyNum(MonthlyAggData$x,big.mark=",")
      MonthlyAggData$count<- MonthlyAggData$x
      
      ggplot(data = MonthlyAggData,
             mapping = aes(x = Timeframe, y = x, color = Category)) + 
        theme(legend.position = "bottom") +
        geom_line() + 
        geom_point(aes(color = Category)) + 
        labs(y = "Count of Objects", x = input$univariate
        )
      
      
    } else if (input$chart_type == "bar chart" ) {
      the_data = aggregate(list(count = data[[input$bivariate]]), 
                           by = list(category = data[[input$univariate]], 
                                     key = data[[input$bivariate]]),
                           length)
      
      the_data$timeframe <- as.Date(the_data$key,format="%Y-%m-%d")
      the_data$Month_Yr <- format(as.Date(the_data$timeframe), "%Y-%m")
      the_data$MonthYear <- as.yearmon(the_data$Month_Yr, "%Y-%m") # Only For Line Chart
      #Group By and Agrregation by MonthYear and Category
      MonthlyAggData <- aggregate(the_data$count, 
                                  by=list(Timeframe=the_data$MonthYear
                                          ,Category=the_data$category), FUN=sum)
      # MonthlyAggData$count<- prettyNum(MonthlyAggData$x,big.mark=",")
      MonthlyAggData$count<- MonthlyAggData$x
      
      plot_ly(MonthlyAggData, 
              x = MonthlyAggData$Timeframe,
              y = MonthlyAggData$count, color = MonthlyAggData$Category, type = "bar") %>%
        layout(title = '',margin = list(b=100, l=100), 
               xaxis = list(title = input$univariate, 
                            showgrid = TRUE,
                            categoryarray = MonthlyAggData$category,
                            categoryorder = "array"), 
               yaxis = list(title = "Count of Objects",tickformat=",d",showgrid = TRUE),
               showlegend = TRUE)
      
    } else if (input$chart_type == "density chart" ) {
      plot_ly(x = ~data[[input$univariate]], y = ~data[[input$bivariate]], type = 'scatter', mode = 'lines', fill = 'tozeroy') %>% 
        layout(xaxis = list(title = ''),
               yaxis = list(title = 'Density'))
      
    } else {
      div()
    }
  }
})

