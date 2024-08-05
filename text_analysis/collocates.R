# Loading necessary packages.
library(quanteda)
library(quanteda.textstats)
library(tidyverse)

# Read the "kodu" concordances file into R.
file_path <- "kodu_concs.txt"
concordances <- readLines(file_path)
stopwords_file <- "estonian-stopwords-lemmas.txt"
stopwords <- readLines(stopwords_file)

# Creating a corpus from the concordances.
corpus <- corpus(concordances)

# Finding collocates.
tokens <- tokens(corpus, remove_numbers = TRUE, remove_punct = TRUE, remove_symbols = TRUE)
collocations <- textstat_collocations(tokens, min_count = 10)
collocations_filtered <- collocations %>%
  filter(grepl("kodu", collocation)) %>%
  arrange(desc(lambda))

# Displaying the results.
collocations_filtered

# Creating a DFM.
tokens2 <- tokens_remove(tokens, stopwords)

dfm.sentences <- dfm(tokens2)

similarity.words <- textstat_simil(dfm.sentences, dfm.sentences[,"kodu"], margin = "features", method = "cosine")

# Displaying the results.
head(similarity.words[order(similarity.words[,1], decreasing = T),], 11)
