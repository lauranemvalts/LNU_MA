# Loading necessary packages.
library(tidyverse)

# Entering output path.
output_directory <- "C:/GitHub/lnu_ma/spatial_analysis/data"
setwd("C:/GitHub/lnu_ma/spatial_analysis/data")

# Get a list of files that follow the pattern. Although the code is meant for looping a folder of files, it also suits for processing an individual file due to distinct pattern.
file_list <- list.files(pattern = "_\\d+_locations\\.txt")

# Looping over the files.
for (file in file_list) {
  # Reading the files.
  valiseesti <- readLines(file, encoding = "UTF-8")
  
  # Harmonising the results.
  valiseesti <- tolower(valiseesti)
  valiseesti <- gsub("usa-[[:alpha:]]+", "usa", valiseesti) # Fixing the grammatical cases behind USA.
  valiseesti <- gsub("[^[:alpha:]0-9 -]", "", valiseesti) # Erasing everything except the non-alphabetical and numerical characters, whitespaces and hyphens.
  valiseesti <- gsub("p p| p | p$", "", valiseesti) # Erasing previously unremoved html paragraph marks.
  valiseesti <- gsub("\\s+", " ", valiseesti) # Replacing multiple whitespaces with single whitespace.
  valiseesti <- gsub(" $", "", valiseesti) # Removing whitespaces at the end of the locations.
  valiseesti <- gsub("^\\s+", "", valiseesti) # Removing whitespaces at the beginning of the locations.
  
  # Converting the modified content back to a data frame.
  valiseesti <- data.frame(V1 = valiseesti, stringsAsFactors = FALSE)
  
  # Counting occurrences of each place name.
  identsed <- valiseesti %>%
    group_by(V1) %>%
    summarize(count = n())
  
  identsed <- identsed[order(identsed$count,decreasing = TRUE),]
  
  # Writing unique place names to a file in the output directory.
  write.table(identsed, file.path(output_directory, paste0("unique_", file)), sep="\t", quote = FALSE, row.names = FALSE)
  
  # Getting the top 1% most frequent place names.
  top_1_percent <- identsed %>%
    arrange(desc(count)) %>%
    slice_head(n = floor(0.01 * nrow(.)))
  
  # Writing the top 1% most frequent place names to a file in the output directory.
  write.table(top_1_percent, file.path(output_directory, paste0("top_1_percent_", file)), sep="\t", quote = FALSE, row.names = FALSE)
}

# Getting list of files starting with "top_1_percent_".
top_files <- list.files(path = output_directory, pattern = "^top_1_percent_", full.names = TRUE)

# Initialising an empty data frame to store merged data.
merged_data <- data.frame()

# Looping over each file and read its contents into merged_data.
for (file in top_files) {
  
  # Reading the file.
  top_data <- read.table(file, header = TRUE, sep = "\t", stringsAsFactors = FALSE)
  
  # Merging the data.
  merged_data <- rbind(merged_data, top_data)
}

# Grouping and summarising the locations.
merged_summarized <- merged_data %>%
  group_by(V1) %>%
  summarize(count = sum(count)) %>%
  arrange(desc(count)) # Sort by count in descending order

# Writing the merged and summarized data to a file.
write.table(merged_summarized, file.path(output_directory, "merged_top_1_percent_sorted.txt"), sep="\t", quote = FALSE, row.names = FALSE)

