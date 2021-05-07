# Set up working directory
setwd("~")
setwd("Detainer-Warrant-PDF-Parser/input")

# Load required libraries
library(pdftools)
library(stringr)
library(data.table)
library(jsonlite)
library(dplyr)

# List all files within a directory
filenames = 
  list.files()

# Read in each PDF into a list
datalist = 
  lapply(
    filenames, 
    function(x){
      pdftools::pdf_text(x)
      }
    )

# Unlist the object
datalist = 
  unlist(
    datalist
    )

# Format the object as a dataframe
df = 
  lapply(
    datalist, 
    function(x){
      data.frame(
        matrix(
          unlist(x), 
          nrow =
            length(x), 
          byrow = TRUE
          )
        )
      }
    )

# Convert to "pretty" JSON
df2 = 
  jsonlite::toJSON(
    df, 
    auto_unbox = TRUE, 
    pretty = TRUE
    )

# Extract all IDs (strings that end with "DT")
unique_ids = 
  stringr::str_extract_all(
    df2, 
    ".{6}DT"
    )

# Unlist and convert to vector
unique_ids = 
  as.vector(
    unlist(
      unique_ids
      )
    )

# Remove any instance of 'n' before the id"
unique_ids = 
  gsub(
    "n",
    "",
    unique_ids
  )

# # Split the text into vectors using `DT`
df3 = 
  str_split(
    df2, 
    "DT"
  )

# Remove the first vector from the list object
df3 = 
  df3[[1]][-1]

# Extract Zip Codes 
df4 = 
  lapply(
    df3, 
    function(x){
      str_extract(
        x, 
        "TN \\d{5}"
      )
    }
  )

# Unlist zip_codes
zip_codes = 
  unlist(
    df4
    )

# Remove "TN " from zipcodes
 zip_codes = 
  gsub(
    "TN ",
    "", 
    zip_codes
    )

# Extract dates
dates = 
  str_extract(
    df3, 
    "\\d+/\\d+/\\d+"
    )

# Create a dataframe out of all three variables
warrants = 
  data.frame(
    unique_ids,
    zip_codes, 
    dates
    )

# Remove duplicated detainer warrants
warrants = 
  warrants[
    !duplicated(
      warrants$unique_ids
      ),
    ]

# Write out results to a CSV
setwd("~")
setwd("Detainer-Warrant-PDF-Parser/output")

write.csv(
  warrants, 
  "detainer-warrants.csv", 
  row.names = 
    FALSE
  )
