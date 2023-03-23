body <- function(){
  dashboardBody(
   ##### loader #####
   shinybusy::add_busy_gif(src = "loader.gif", 
                           position = "full-page", 
                           overlay_color = "rgb(208 202 202 / 50%);"),
    
    #### css file #####
    tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "task.css")),
    useShinyalert(),
    shinyjs::useShinyjs(),
    #Loader js code
    tags$head(tags$script(src="js/loader.js")),
    uiOutput("render_body")
  )
}
