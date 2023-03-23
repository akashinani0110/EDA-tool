sidebar_menu <- function(...){
    sidebarMenu(id = "sidebar",
                menuItem(text = "Summary",
                         tabName = "summary",
                         icon = NULL
                ),
                menuItem(text = "Search",
                         tabName = "name",
                         icon = NULL
                ),
                menuItem(text = "EDA",
                         tabName = "eda_tool"
                ),
                menuItem(text = "Note(s)",
                         tabName = "alert_show",
                         badgeLabel = "Info"
                )
    )
}