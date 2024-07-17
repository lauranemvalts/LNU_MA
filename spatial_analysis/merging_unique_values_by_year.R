# Loading the necessary library.
library(tidyverse)

# Entering output path.
output_directory <- "enter here output path"

# Getting a list of files that follow the pattern.
file_list <- list.files(pattern = ".txt")

# Getting a list of files starting with "unique_".
unique_files <- list.files(path = output_directory, pattern = "^unique_", full.names = TRUE)

# Initialising an empty data frame to store merged data.
merged_data <- data.frame()

# Looping over each file and read its contents into merged_data.
for (file in unique_files) {
  # Reading the file.
  top_data <- read.table(file, header = TRUE, sep = "\t", stringsAsFactors = FALSE)
  
  # Merging data.
  merged_data <- rbind(merged_data, top_data)
}

# Grouping and summing by locations.
merged_summarized <- merged_data %>%
  group_by(V1) %>%
  summarize(count = sum(count)) %>%
  arrange(desc(count)) # Sort by count in descending order

# Writing the merged and summarised data to a file.
write.table(merged_summarized, file.path(output_directory, "merged_sorted.txt"), sep="\t", quote = FALSE, row.names = FALSE)

