## -- At Heron Data we work with a lot of bank transaction data

## --------------------------Import Libraries

suppressPackageStartupMessages(library(ggrepel))
suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(lubridate))
suppressPackageStartupMessages(library(formattable))
suppressPackageStartupMessages(library(gridExtra))
suppressPackageStartupMessages(library(knitr))
suppressPackageStartupMessages(library(readxl))
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(tidyquant))
suppressPackageStartupMessages(library(patchwork))
suppressPackageStartupMessages(library(glue))
suppressPackageStartupMessages(library(easypackages))
suppressPackageStartupMessages(library(ggthemes))
suppressPackageStartupMessages(library(cowplot))
suppressPackageStartupMessages(library(gghighlight))
suppressPackageStartupMessages(library(gt))
suppressPackageStartupMessages(library(skimr))
suppressPackageStartupMessages(library(xlsx))
suppressPackageStartupMessages(library(jsonlite))

## --**Schema**
  
#- **timestamp** - `datetime` the time at which the transaction occurred
#- **description** - `string` a variable length string that explains what the transaction represents
#- **amount** - `float` the value of transaction

# One of the ways that we add value for customers is by identifying **recurring transactions**
# — transactions that occur at a regular cadence. You can think of this as transactions
# like subscriptions (internet, phone, Netflix, Spotify), rent, or even something like a weekly company lunch.


## --------------Read in data
json_file <- read_json("./raw_data/example.json", simplifyVector = TRUE)

data_tbl <- as.data.frame(json_file)

# Clean up date format
data_tbl <- data_tbl %>%
  mutate(transactions.date = transactions.date %>% ymd()) %>%
  # Get the day of the transaction
  mutate(day = substr(transactions.date, 9, 10)) %>%
  # clean up transaction column by removing all alphanumeric 
  mutate(transactions.description = trimws(gsub("\\w*[0-9]+\\w*\\s*", "", transactions.description)))

# Quick stats

data_tbl %>% skim()

# Snapshot of data
data_tbl %>% glimpse()
#---------------Approach--------------------------------
# Rules based approach
# A recurring event occurs at regular time intervals
# To identify recurrent transactions, we have to build an algorithm that spots patterns in the data
# with focus on frequency and amount

## ------------------Transactions Cleaner


data_tbl %>%
  ggplot(aes(transactions.date,transactions.amount, color=transactions.description, fill=transactions.description)) +
  geom_point()

# Function to identify recurring transaction
identify_recurring_transactions <- function(df){
  
  # Number of occurences of amount for each month
  data <- df %>%
    select(day,transactions.description,transactions.amount) %>%
    group_by(day,transactions.description,transactions.amount) %>%
    summarize(freq=n()) %>%
    ungroup() %>%
    mutate(recur_ind = case_when(
      freq >= 4 ~ 'Yes',
      TRUE ~ 'No'
    )
    )
}

identify_recurring_transactions(data_tbl)
