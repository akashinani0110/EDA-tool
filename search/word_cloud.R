#### On click of link to get scientific name word cloud ####
observeEvent(input$wordcloud_scientific, {
  search$wordcloud_element = "scientific"
})

#### On click of link to get vernacular name word cloud ####
observeEvent(input$wordcloud_vernaciular, {
  search$wordcloud_element = "vernacular"
})


#### Render wordcloud ui if any of the above link is selected ####
#### Add javascript function to fetch selected word ####
output$get_wordcloud_ui <- renderUI({
  if (length(search$wordcloud_element) > 0) {
    fluidRow(wordcloud2Output("wordcloud"), 
             tags$script(HTML(
               "$(document).on('click', '#canvas', function() {",
               'word = document.getElementById("wcSpan").innerHTML;',
               "Shiny.onInputChange('selected_word', word);",
               "});"
             )),style = "padding:2%")
  } else div()
})


#### render wordcloud2 for top 200 values ####
output$wordcloud = renderWordcloud2({
  if (length(search$wordcloud_element) > 0) {
    if (search$wordcloud_element == "scientific") {
      data = data_value$scientific_name[1:200,]
    } else if (search$wordcloud_element == "vernacular") {
      data = data_value$vernacular_name[1:200,]
    }
    wordcloud2(data)
  }
})


#### Prefill the selected word to search box ####
observeEvent(input$selected_word, {
  # Get the value in correct format
  value = unlist(strsplit(input$selected_word, ":"))[1]
  
  # Update search box based on element selected for scientific /vernacular
  if (search$wordcloud_element == "scientific") {
    updateSelectInput(session, inputId = "scientific",
                      label = NULL, selected = value)
  } else if (search$wordcloud_element == "vernacular") {
    updateSelectInput(session, inputId = "vernacular",
                      label = NULL, selected = value)
  }
})