# Loading necessary libraries.
library(tidyverse)
library(scales)

# Reading the data from the text file.
data <- read.table("merged_sorted.txt", sep = "\t", header = TRUE)

# Taking only the top 20 most frequent locations.
data <- head(data, 20)

# Creating the bar plot using ggplot2.
ggplot(data, aes(x = count, y = reorder(V1, count))) +
  geom_bar(stat = "identity", fill = "#00BFC4") +
  labs(title = "20 most frequent locations: Teataja / Eesti Teataja", x = "Frequency", y = "Location") +
  scale_x_continuous(labels = comma) +  # Format x-axis labels as integers
  theme_minimal() +
  theme(axis.text.y = element_text(hjust = 0))
