render_body <- function(...){
        tabItems(
          tabItem(tabName = "summary", uiOutput("render_summary")),
          tabItem(tabName = "name", uiOutput("render_search_name")),
          tabItem(tabName = "eda_tool", uiOutput("eda_tool")),
          tabItem(tabName = "alert_show", uiOutput("show_alert"))
        )
}