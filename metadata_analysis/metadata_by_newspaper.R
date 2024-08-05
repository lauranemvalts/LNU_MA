# Loading necessary libraries.
library(data.table)
library(tidyverse)
library(gridExtra)

# Loading the dataset.
data <- fread("exile_meta.tsv", header = TRUE, sep = "\t", data.table = FALSE)

# Extracting information about the newspaper Välis-Eesti.
valiseesti_combined <- data %>%
  filter(str_detect(docid, "valiseesti")) %>%
  filter(year >= 1944 & year <= 1991) %>% 
  group_by(year) %>%                          
  summarize(count = n()) %>%
  mutate(object_name = "Välis-Eesti")

# Calculating the sum of all pages.
valiseesti_sum <- sum(valiseesti_combined$count)
valiseesti_sum #8361

# Graph for Välis-Eesti.
valiseesti <- ggplot(valiseesti_combined, aes(x = factor(year), y = count)) +
  geom_bar(stat = "identity", fill = "#00BFC4") +
  labs(title = "Count of pages per year: Välis-Eesti",
       x = "Year",
       y = "Count of pages") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Saving the graph separately, if desired.
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

# Combining the results.
estdagbladet_stockholmstid_combined <- bind_rows(result_estdagbladet, result_stockholmstid) %>%
  group_by(year, object_name) %>%
  summarise(count = sum(count))

# Calculating the sum of all pages.
estdagbladet_sum <- sum(result_estdagbladet$count)
estdagbladet_sum #25773

stockholmstid_sum <- sum(result_stockholmstid$count)
stockholmstid_sum #5529

# Combining the results.
estdagbladet_stockholmstid_sum <- sum(estdagbladet_stockholmstid_combined$count)
estdagbladet_stockholmstid_sum #31302

# Graph for Eesti Päevaleht and Stockholms-Tidningen Eestlastele.
estdagbladet_stockholmstid <- ggplot(estdagbladet_stockholmstid_combined, aes(x = factor(year), y = count, fill = object_name)) +
  geom_bar(stat = "identity") +
  labs(title = "Count of pages per year: Eesti Päevaleht / Stockholms-Tidningen Eestlastele",
       x = "Year",
       y = "Count of pages",
       fill = "Newspaper") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Saving the graph separately, if desired.
#ggsave("estdagbladet_stockholmstid.png", width = 10, height = 6, units = "in")

# Extracting information about Teataja and Eesti Teataja.
result_eestiteatajastock <- data %>%
  filter(str_detect(docid, "eestiteatajastock")) %>%
  filter(year >= 1944 & year <= 1991) %>% 
  group_by(year) %>%                          
  summarize(count = n()) %>%
  mutate(object_name = "Eesti Teataja")

result_teatajapoliit <- data %>%
  filter(str_detect(docid, "teatajapoliit")) %>%
  filter(year >= 1944 & year <= 1991) %>% 
  group_by(year) %>%                          
  summarize(count = n()) %>%
  mutate(object_name = "Teataja")

# Combining the results.
eestiteatajastock_teatajapoliit_combined <- bind_rows(result_eestiteatajastock, result_teatajapoliit) %>%
  group_by(year, object_name) %>%
  summarise(count = sum(count))

# All pages summarised.
eestiteatajastock_sum <- sum(result_eestiteatajastock$count)
eestiteatajastock_sum #3339

teatajapoliit_sum <- sum(result_teatajapoliit$count)
teatajapoliit_sum #8430

# Combining the results.
eestiteatajastock_teatajapoliit_sum <- sum(eestiteatajastock_teatajapoliit_combined$count)
eestiteatajastock_teatajapoliit_sum #11769

# Graph for Teataja and Eesti Teataja.
eestiteatajastock_teatajapoliit <- ggplot(eestiteatajastock_teatajapoliit_combined, aes(x = factor(year), y = count, fill = object_name)) +
  geom_bar(stat = "identity") +
  labs(title = "Count of pages per year: Teataja / Eesti Teataja",
       x = "Year",
       y = "Count of pages",
       fill = "Newspaper") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Saving the graph separately, if desired.
#ggsave("eestiteatajastock_teatajapoliit.png", width = 10, height = 6, units = "in")

# Combining the plots using grid.arrange. The combined plot shows the newspapers' page counts per year.
combined_plot <- grid.arrange(valiseesti, estdagbladet_stockholmstid, eestiteatajastock_teatajapoliit, ncol = 1)

# Saving the combined plot.
ggsave("newspapers_by_pages.png", plot = combined_plot, width = 10, height = 6, units = "in")

# Combining all the results.
all_newspapers <- bind_rows(valiseesti_combined, estdagbladet_stockholmstid_combined, eestiteatajastock_teatajapoliit_combined)
all_newspapers$object_name <- gsub("Eesti Päevaleht|Stockholms-Tidningen\nEestlastele", "Eesti Päevaleht\n/ Stockholms-Tidningen\nEestlastele", all_newspapers$object_name)
all_newspapers$object_name <- gsub("Eesti Teataja|Teataja", "Teataja / Eesti Teataja", all_newspapers$object_name)

all_newspapers <- aggregate(count ~ year + object_name, data = all_newspapers, sum)

# Calculating the overall average page count per year for all newspapers.
overall_avg <- all_newspapers %>%
  group_by(year) %>%
  summarize(overall_avg_count = mean(count))

overall_mean <- mean(overall_avg$overall_avg_count)
overall_mean

# Creating the graph, which shows the combined average page counts per year as a barplot and different newspapers' page counts on line plots.
ggplot() +
  geom_bar(data = overall_avg, aes(x = year, y = overall_avg_count), stat = "identity", fill = "gray40") +
  geom_line(data = all_newspapers, aes(x = year, y = count, group = object_name, color = object_name), linewidth=1.2) +
  labs(title = "Changes in the number of newspaper pages per year with overall average",
       x = "Year",
       y = "Pages",
       color = "Newspaper")

# Saving the combined plot.
ggsave("newspapers_w_avg.png", width = 10, height = 6, units = "in")
