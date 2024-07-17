# Loading necessary libraries.
library(dplyr)

# Reading the unique locations by decade.
file1 <- read.table("teatajapoliit_40s.txt", sep="\t", header=TRUE, stringsAsFactors=FALSE)

# Reading the merged coordinates file.
file2 <- read.table("merged_coordinates.txt", sep=",", header=TRUE, stringsAsFactors=FALSE)

# Performing a left join to keep the order of file1.
merged_df <- left_join(file1, file2[, c("V1", "lat", "lon")], by="V1")

# Replacing NA values with "NO MATCH" only where there's no corresponding V1 value in file2.
merged_df <- merged_df %>%
  mutate(lat = ifelse(is.na(lat) & V1 %in% setdiff(file1$V1, file2$V1), "NO MATCH", lat),
         lon = ifelse(is.na(lon) & V1 %in% setdiff(file1$V1, file2$V1), "NO MATCH", lon))

# Saving the merged DataFrame to a new CSV file.
write.csv(merged_df, "teatajapoliit_40_coordinates.csv", row.names=FALSE)
