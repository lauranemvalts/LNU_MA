# Reading the CSV file containing coordinates data.
coordinates_data <- read.csv("august_91_coordinates.txt")

# Defining broadly the most northern, southern, eastern and western coordinates of Estonia.
estonia_bbox <- list(
  north = 59.68,
  south = 57.51,
  east = 28.21, 
  west = 21.83
)

# Filtering coordinates within the borders.
coordinates_in_estonia <- subset(coordinates_data, 
                                 lat >= estonia_bbox$south & 
                                   lat <= estonia_bbox$north & 
                                   lon >= estonia_bbox$west & 
                                   lon <= estonia_bbox$east)

# Deleting all the place names containing the word "eesti", as these hide other locations.
coordinates_in_estonia <- coordinates_in_estonia %>%
  filter(!grepl("eesti", V1))

# Writing the filtered data to a new CSV file.
write.csv(coordinates_in_estonia, "august_91_estonia_coordinates.txt", row.names = FALSE, quote = FALSE)
