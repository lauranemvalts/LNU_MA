# Loading necessary libraries.
library(tidyverse)
library(scales)

# Reading the data from the text file.
data <- read.table("unique_august_91_locations.txt", sep = "\t", header = TRUE)

# Taking only the top 20 most frequent locations.
data <- head(data, 20)

# Creating the bar plot using ggplot2.
ggplot(data, aes(x = count, y = reorder(V1, count))) +
  geom_bar(stat = "identity", fill = "#00BFC4") +
  labs(title = "20 most frequent locations: August 1991", x = "Frequency", y = "Location") +
  scale_x_continuous(labels = comma) +  # Format x-axis labels as integers
  theme(axis.text.y = element_text(hjust = 0))

# The barplot is downloaded from the user interface of the RStudio, with parameters Width = 900 and Height = 495.
