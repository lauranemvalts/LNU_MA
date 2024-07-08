# Loading the necessary library.
library(tidyverse)

# Entering output path.
output_directory <- "enter here output path"

# Getting a list of files.
file_list <- list.files(pattern = "*.txt")

# Creating an empty list to store data frames.
data_list <- list()

# Looping over each file.
for (file in file_list) {
  # Reading file with tab (\t) as separator.
  data <- read.table(file, header = TRUE, fill = TRUE, sep = "\t", stringsAsFactors = FALSE)
  data$V1 <- gsub('"', '', data$V1)
  data$V1 <- gsub('\\s+$', '', data$V1)
  data$V1 <- gsub(',', '', data$V1)
  
  # Appending data to the list.
  data_list[[file]] <- data
}

# Combining all data frames into one.
combined_data <- do.call(rbind, data_list)

# Aggregating the counts for each unique value (V1).
final_data <- aggregate(count ~ V1, combined_data, sum)

# Sorting by counts in descending order.
final_data <- final_data[order(-final_data$count), ]

# Creating a separate file consisting of the merged and summarised locations by decade.
write.table(final_data, "teatajapoliit_40s_merged_data.txt", sep = "\t", quote = FALSE, row.names = FALSE)