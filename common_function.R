#'@name get_count
#'@title appsilon_value_box
#'@author Akash Inani
#'@description Get customized Value Box 
#'@param value Value to be displayed
#'@param subtitle Title to be displayed
#'@param ... variadic argument supporting the following
#'execute (logical) should the request be executed
#'verbose (logical, default F) should verbose information be printed
#'@return get value box
custom_value_box <- function (value, subtitle,  ...) {
  .args <- list(...)
  .nargs <- names(.args)
  
  execute <- T
  verbose <- F
  
  if ("verbose" %in% .nargs) verbose <- .args[["verbose"]]
  
  if ("execute" %in% .nargs) execute <- .args[["execute"]]
  
  if (verbose) {
    cat(subtitle)
    cat(value)
  }
  
  if (execute) {
    if (length(value) > 0)
      if (is.numeric(value))
        value = prettyNum(value, big.mark = ",")
    
    div(
      fluidRow(id = "value_box_value",
               value,
               style = "font-size: 25px; font-weight:bold"),
      fluidRow(id = "value_box_subtitle",
               subtitle,
               style = "font-size: 17px;"),
      style = "background: linear-gradient(45deg, #344570, #9bcc9c); color: white; 
               border-radius: 20px;text-align: center;padding:1%; padding-top:0%"
    )
  } else div()
}


#'@name tabset_box_output
#'@title appsilon_box_output
#'@author Akash Inani
#'@description Get Box with tabset (Plot and table)
#'@param id plot and table id
#'@param label label for box
#'@param ... variadic argument supporting the following
#'execute (logical) should the request be executed
#'verbose (logical, default F) should verbose information be printed
#'@return get tabset box output
tabset_box_output <- function (id, label, ...) {
  .args <- list(...)
  .nargs <- names(.args)
  
  execute <- T
  verbose <- F
  
  if ("verbose" %in% .nargs) verbose <- .args[["verbose"]]
  
  if ("execute" %in% .nargs) execute <- .args[["execute"]]
  
  if (verbose) {
    cat(subtitle)
    cat(value)
  }
  
  if (execute) {
    box(title = label,
        solidHeader = T,
        collapsible = T,
        status = "primary",
        collapsed = F,
        tabsetPanel(id = "statistical_analysis2",
                    tabPanel("Plot - Top 10", plotlyOutput(paste0(id, "_plot"))),
                    tabPanel("Table", dataTableOutput(paste0(id, "_dt"))))
    )
  }
}


get_data_info <- function(data, ...) {
  if (length(intersect(colnames(data), c("id","scientificName","taxonRank", "higherClassification", "vernacularName",
                                         "longitudeDecimal", "latitudeDecimal", "countryCode", "eventDate") ) == 9)) {
    
    taxon_rank = as.data.frame(table(data$taxonRank))
    higerClass = as.data.frame(table(data$higherClassification))
    kingdom = unlist(strsplit(x = as.character(higerClass$Var1[1]), split = "|", fixed = T)[[1]][1])
    family = unlist(strsplit(x = as.character(higerClass$Var1[1]), split = "|", fixed = T)[[1]][2])
    
    countrycode = as.data.frame(table(data$countryCode))
    countrycode = countrycode[order(countrycode$Freq, decreasing = T), ]
    
    data$eventDate <- format(as.Date(data$eventDate), "%Y-%m")
    eventDate = as.data.frame(table(data$eventDate))
    eventDate = eventDate[order(eventDate$Var1, decreasing = F), ]
    
    start_date = as.character(eventDate[1,1])
    
    return(list("distinct_taxon" = taxon_rank$Var1[1],
                "distinct_kingdom" = kingdom,
                "distinct_start" = start_date,
                "family" = family,
                "distinct_location" = nrow(countrycode),
                "location" = countrycode,
                "event_date" = eventDate,
                "total" = nrow(data) )
    )
  }
}
