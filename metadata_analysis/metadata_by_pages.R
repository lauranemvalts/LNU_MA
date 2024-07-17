# Loading necessary libraries.
library(tidyverse)
library(data.table)

# Loading the dataset that consists of metadata about all the newspapers.
data <- fread("issue_level_meta.tsv", header = TRUE, sep = "\t", data.table = FALSE)

# Filtering the dataset by exile newspapers.
filtered_data <- data[data$section == "Exile newspaper", ]

# Filtering only the necessary columns.
df <- filtered_data[, c("DocumentID", "year", "n_pages")]

# Summarising the data of the different newspapers by year.
sum_by_year <- aggregate(n_pages ~ year, data = df, FUN = sum)

# Creating the graph.
ggplot(sum_by_year, aes(x = year, y = n_pages)) +
  geom_bar(stat = "identity", fill = "#00BFC4") +
  labs(x = "Year", y = "Number of pages",
  title = "Number of pages of exile newspapers by year") + 
  scale_x_continuous(breaks = seq(min(sum_by_year$year), max(sum_by_year$year), by = 20))
