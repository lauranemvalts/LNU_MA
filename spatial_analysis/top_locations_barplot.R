# Loading necessary libraries.
library(tidyverse)
library(scales)

# Reading the data from the text file.
data <- read.table("merged_top_1_percent_sorted.txt", sep = "\t", header = TRUE)

# Separating the top 20 most frequent locations.
data <- head(data, 20)

# Creating barplot using ggplot2.
ggplot(data, aes(x = count, y = reorder(V1, count))) +
  geom_bar(stat = "identity", fill = "#00BFC4") +
  labs(title = "20 most frequent locations: Teataja / Eesti Teataja", x = "Frequency", y = "Location") +
  scale_x_continuous(labels = comma) +
  theme_minimal() +
  theme(axis.text.y = element_text(hjust = 0))