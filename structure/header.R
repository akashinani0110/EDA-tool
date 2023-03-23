header <- function(){
  dashboardHeader(
    title = img(src = "quantzig_logo.jpg",
                style = "width: 90px;height: 90px;"
                ),
      
      # 
    # titleWidth = 110,
    # enable_rightsidebar = FALSE,
    # fixed = TRUE,
    # list(
      uiOutput("render_header")
      # ),
    # dropdownMenuOutput("privilege")
  )
}
shinydashboard::dashboardHeader()