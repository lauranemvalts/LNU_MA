# Loading necessary packages.
library(tidyverse)

# Entering output path.
output_directory <- "enter here output path"

# Geting a list of files that follows the file names' pattern.
file_list <- list.files(pattern = "teatajapoliit_\\d+_locations\\.txt")

# Looping over each file.
for (file in file_list) {
  # Reading the file.
  valiseesti <- readLines(file, encoding = "UTF-8")
  
  # Replacing "USA-" followed by letters and space or end of the line with "USA".
  valiseesti <- gsub("USA-[[:alpha:]]+", "USA", valiseesti)
  
  # Converting words to lowercase.
  valiseesti <- tolower(valiseesti)
  
  # Converting the modified content back to a data frame.
  valiseesti <- data.frame(V1 = valiseesti, stringsAsFactors = FALSE)
  
  # Counting unique locations.
  identsed <- valiseesti %>%
    group_by(V1) %>%
    summarize(count = n())
  
  identsed <- identsed[order(identsed$count,decreasing = TRUE),]
  
  # Creating a file with unique place names.
  write.table(identsed, file.path(output_directory, paste0("unique_", file)), sep="\t", quote = FALSE, row.names = FALSE)
  
  # Acquiring the top 1% most frequent locations.
  top_1_percent <- identsed %>%
    arrange(desc(count)) %>%
    slice_head(n = floor(0.01 * nrow(.)))
  
  # Writing the top 1% most frequent place names to a fseparate file.
  write.table(top_1_percent, file.path(output_directory, paste0("top_1_percent_", file)), sep="\t", quote = FALSE, row.names = FALSE)
}

# Getting list of files starting with "top_1_percent_".
top_files <- list.files(path = output_directory, pattern = "^top_1_percent_", full.names = TRUE)

# Initialising an empty data frame to store merged data.
merged_data <- data.frame()

# Looping over the files consisting of the most frequent place names and read its contents into merged_data.
for (file in top_files) {
  # Reading file.
  top_data <- read.table(file, header = TRUE, sep = "\t", stringsAsFactors = FALSE)
  
  # Merging data.
  merged_data <- rbind(merged_data, top_data)
}

# Grouping by locations (V1), summarising the counts and sorting by count in descending order.
merged_summarized <- merged_data %>%
  group_by(V1) %>%
  summarize(count = sum(count)) %>%
  arrange(desc(count))

# Writing the merged and summarised data to a separate file.
write.table(merged_summarized, file.path(output_directory, "merged_top_1_percent_sorted.txt"), sep="\t", quote = FALSE, row.names = FALSE)

