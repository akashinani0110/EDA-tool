source(paste0(getwd(),"/structure/libraries.R"))
source(paste0(getwd(),"/structure/header.R"))
source(paste0(getwd(),"/structure/sidebar.R"))
source(paste0(getwd(),"/structure/body.R"))

# shinybusy::add_busy_spinner()
shinyUI(
  dashboardPage(
    # will add later 
    # 
    title = tags$head(tags$link(rel = "icon",
                                type = "image/png",
                                href = "quantzig_logo.jpg"),
                      tags$title("Quantzig") ),
    header = header(),
    sidebar = sidebar(),
    body = body()
  )
)

