sidebar <- function(){
  dashboardSidebar(
    width = 110,
    header = div(id = "sidebar_margin_top"),
                sidebarMenuOutput("sidebar_menu")
    )
}