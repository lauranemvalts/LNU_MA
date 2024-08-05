library(tidyverse)

output_directory <- "C:/Users/sinip/MA_valiseesti/FIXED_LOC/teatajapoliit+eestiteatajastock/merging/53"

# Get a list of files that follow the pattern valiseesti_year_locations
file_list <- list.files(pattern = ".txt")

# Loop over each file
for (file in file_list) {
  # Read the file
  valiseesti <- readLines(file, encoding = "UTF-8")
  
  valiseesti <- tolower(valiseesti)
  valiseesti <- gsub("usa-[[:alpha:]]+", "usa", valiseesti) # Grammatical cases behind USA.
  valiseesti <- gsub("[^[:alpha:]0-9 -]", "", valiseesti) # All non-alphabetical and numerical characters, also whitespaces and hyphens.
  valiseesti <- gsub("p p| p | p$", "", valiseesti) # Previously unremoved paragraph marks.
  valiseesti <- gsub("\\s+", " ", valiseesti) # Replacing multiple whitespaces with single whitespace.
  valiseesti <- gsub(" $", "", valiseesti) # Removing whitespaces at the end of the locations.
  valiseesti <- gsub("^\\s+", "", valiseesti) # Removing whitespaces at the beginning of the locations.
  valiseesti <- tolower(valiseesti) # Lowercasing all the entities.
  
  # Convert the modified content back to a data frame
  valiseesti <- data.frame(V1 = valiseesti, stringsAsFactors = FALSE)
  
  # Count occurrences of each place name
  identsed <- valiseesti %>%
    group_by(V1) %>%
    summarize(count = n())
  
  identsed <- identsed[order(identsed$count,decreasing = TRUE),]
  
  # Write unique place names to a file in the output directory
  write.table(identsed, file.path(output_directory, paste0("unique_", file)), sep="\t", quote = FALSE, row.names = FALSE)
  
  # Get the top 1% most frequent place names
  top_1_percent <- identsed %>%
    arrange(desc(count)) %>%
    slice_head(n = floor(0.01 * nrow(.)))
  
  # Write the top 1% most frequent place names to a file in the output directory
  write.table(top_1_percent, file.path(output_directory, paste0("top_1_percent_", file)), sep="\t", quote = FALSE, row.names = FALSE)
}

# Get list of files starting with "top_1_percent_"
top_files <- list.files(path = output_directory, pattern = "^top_1_percent_", full.names = TRUE)

# Initialize an empty data frame to store merged data
merged_data <- data.frame()

# Loop over each file and read its contents into merged_data
for (file in top_files) {
  # Read file
  top_data <- read.table(file, header = TRUE, sep = "\t", stringsAsFactors = FALSE)
  
  # Merge data
  merged_data <- rbind(merged_data, top_data)
}

# Group by place names (V1) and sum the counts
merged_summarized <- merged_data %>%
  group_by(V1) %>%
  summarize(count = sum(count)) %>%
  arrange(desc(count)) # Sort by count in descending order

# Write the merged and summarized data to a file
write.table(merged_summarized, file.path(output_directory, "merged_top_1_percent_sorted.txt"), sep="\t", quote = FALSE, row.names = FALSE)

