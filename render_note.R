output$show_alert <- renderUI({
    div(includeMarkdown(paste0(getwd(), "/README.md")), 
        style = "background: white; padding-left:1%")
})