# Loading necessary libraries.
library(data.table)
library(tidyverse)
library(gridExtra)

# Extracting the column names from the header of the whole dataset.
data_header <- fread("subset_meta_all_pages.tsv", header = TRUE, sep = "\t", data.table = FALSE, nrows = 10)
column_names <- colnames(data_header)

# Loading the dataset consisting of only the information about the research materials.
data <- fread("exile_meta.tsv", header = FALSE, sep = "\t", data.table = FALSE)

# Merging the header and exile newspapers' metadata.
colnames(data) <- column_names

# Extracting information about Välis-Eesti.
result_valiseesti <- data %>%
  filter(str_detect(docid, "valiseesti")) %>%
  filter(year >= 1944 & year <= 1991) %>% 
  group_by(year) %>%                          
  summarize(count = n()) %>%
  mutate(object_name = "Välis-Eesti")

# All pages summarised.
valiseesti_sum <- sum(result_valiseesti$count)
valiseesti_sum #8361

# Graph for Välis-Eesti.
valiseesti <- ggplot(result_valiseesti, aes(x = factor(year), y = count)) +
  geom_bar(stat = "identity", fill = "#00BFC4") +
  labs(title = "Count of pages per year: Välis-Eesti",
       x = "Year",
       y = "Count of pages") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#ggsave("valiseesti.png", width = 10, height = 6, units = "in")

# Extracting information about Eesti Päevaleht and Stockholms-Tidningen Eestlastele.
result_estdagbladet <- data %>%
  filter(str_detect(docid, "estdagbladet")) %>%
  filter(year >= 1944 & year <= 1991) %>% 
  group_by(year) %>%                          
  summarize(count = n()) %>%
  mutate(object_name = "Eesti Päevaleht")

result_stockholmstid <- data %>%
  filter(str_detect(docid, "stockholmstid")) %>%
  filter(year >= 1944 & year <= 1991) %>% 
  group_by(year) %>%                          
  summarize(count = n()) %>%
  mutate(object_name = "Stockholms-Tidningen\nEestlastele")

combined_result <- bind_rows(result_estdagbladet, result_stockholmstid) %>%
  group_by(year, object_name) %>%
  summarise(count = sum(count))

# All pages summarised.
estdagbladet_sum <- sum(result_estdagbladet$count)
estdagbladet_sum #25773

stockholmstid_sum <- sum(result_stockholmstid$count)
stockholmstid_sum #5529

estdagbladet_stockholmstid_sum <- sum(combined_result$count)
estdagbladet_stockholmstid_sum #31302

# Graph for Eesti Päevaleht and Stockholms-Tidningen Eestlastele.
estdagbladet_stockholmstid <- ggplot(combined_result, aes(x = factor(year), y = count, fill = object_name)) +
  geom_bar(stat = "identity") +
  labs(title = "Count of pages per year: Eesti Päevaleht / Stockholms-Tidningen Eestlastele",
       x = "Year",
       y = "Count of pages",
       fill = "Newspaper") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#ggsave("estdagbladet_stockholmstid.png", width = 10, height = 6, units = "in")

# Extracting information about Teataja and Eesti Teataja.
result_eestiteatajastock <- data %>%
  filter(str_detect(docid, "eestiteatajastock")) %>%
  filter(year >= 1944 & year <= 1991) %>% 
  group_by(year) %>%                          
  summarize(count = n()) %>%
  mutate(object_name = "Eesti Teataja")

result_teatajapoliit <- data_all %>%
  filter(str_detect(docid, "teatajapoliit")) %>%
  filter(year >= 1944 & year <= 1991) %>% 
  group_by(year) %>%                          
  summarize(count = n()) %>%
  mutate(object_name = "Teataja")

combined_result2 <- bind_rows(result_eestiteatajastock, result_teatajapoliit) %>%
  group_by(year, object_name) %>%
  summarise(count = sum(count))

# All pages summarised.
eestiteatajastock_sum <- sum(result_eestiteatajastock$count)
eestiteatajastock_sum #3339

teatajapoliit_sum <- sum(result_teatajapoliit$count)
teatajapoliit_sum #8430

eestiteatajastock_teatajapoliit_sum <- sum(combined_result2$count)
eestiteatajastock_teatajapoliit_sum #11769

# Graph for Teataja and Eesti Teataja.
eestiteatajastock_teatajapoliit <- ggplot(combined_result2, aes(x = factor(year), y = count, fill = object_name)) +
  geom_bar(stat = "identity") +
  labs(title = "Count of pages per year: Teataja / Eesti Teataja",
       x = "Year",
       y = "Count of pages",
       fill = "Newspaper") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#ggsave("eestiteatajastock_teatajapoliit.png", width = 10, height = 6, units = "in")

# Combining the plots using grid.arrange.
combined_plot <- grid.arrange(estdagbladet_stockholmstid, eestiteatajastock_teatajapoliit, valiseesti, ncol = 1)

ggsave("combined_plot.png", plot = combined_plot, width = 10, height = 6, units = "in")

all_newspapers <- bind_rows(result_valiseesti, combined_result, combined_result2)

# Calculating the overall average count for all newspapers.
overall_avg <- all_newspapers %>%
  group_by(year) %>%
  summarize(overall_avg_count = mean(count))

overall_mean <- mean(overall_avg$overall_avg_count)
overall_mean

# Creating the barplot + line graph with ggplot2.
ggplot() +
  geom_bar(data = overall_avg, aes(x = year, y = overall_avg_count), stat = "identity", fill = "gray40") +
  geom_line(data = all_newspapers, aes(x = year, y = count, group = object_name, color = object_name), linewidth=1.2) +
  labs(title = "Changes in the number of newspaper pages per year with overall average",
       x = "Year",
       y = "Pages",
       color = "Newspaper")

ggsave("all_newspapers.png", width = 10, height = 6, units = "in")
