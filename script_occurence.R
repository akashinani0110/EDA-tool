library(data.table)
library(vroom)
library(jsonlite)
library(dplyr)

json = jsonlite::fromJSON("Data/mapping.json")

col_select = c("id", "scientificName", "taxonRank", "higherClassification", "vernacularName", "longitudeDecimal",
               "latitudeDecimal", "countryCode", "eventDate")

file_path = "C:\\Users\\akashinani\\Documents\\biodiversity-data.tar\\biodiversity-data\\biodiversity-data\\occurence.csv"

# Set the buffer size (in number of rows)
buffer_size <- 1000000


# Initialize an empty data table

# create empty data table

skip_row = 0
# loop through the file and read in chunks
repeat {
  head = F
  if (skip_row == 0) head = T
  buffer <- fread(file = file_path,
                  skip = skip_row,
                  nrows = buffer_size,
                  header = head,
                  select = c("Numbering of column"),
                  sep = ",")
  if (nrow(buffer) == 0) break # exit loop if end of file is reached
  colnames(buffer) = col_select
  print(skip_row)
  lapply(1:37, function(i){
    var = json[[i]]
    df = subset(buffer, buffer$scientificName %in% var)
    print(nrow(df))
    filePath = paste0("Data/occurence_",i,".csv")
    if (file.exists(filePath)) {
      write.table(df, filePath, sep = ",", row.names = FALSE, col.names = TRUE, append = TRUE)
    } else {
      write.table(df, filePath, sep = ",", row.names = FALSE, col.names = TRUE, append = FALSE)
    }
  })
  skip_row = skip_row + buffer_size
}


a = vroom(file = file.choose(), col_select = c("CoreId", "accessURI"))
View(head(a))
colnames(a) = c("id", "accessURI")
write.table(a, "Data/URI.csv" , sep = ",", row.names = FALSE, col.names = TRUE, append = TRUE)


lapply(1:37, function(i){
  fread(file = paste0("Data/occurence_",1,".csv"),
               header = T,
               sep = ",")
  
  b = left_join(data, a, by = "id")
  
  write.table(b, paste0("Data/occurence_",i,".csv") , sep = ",", row.names = FALSE, col.names = TRUE, append = FALSE)
  
  
})


