# This is where we should do the analysis on the data and where we should save any 
# graphs to the figs directory.

# This just loads the covid data in to R. It'll be saved as the variable covid which
# is a data.frame class because we defined the data as covid in the wrangle-data.R
# file. Tidyverse is for any changes to the data that need to be made and ggplot is
# for visualization.
library(tidyverse)
library(ggplot2)
load("rdata/covid.rda")
head(covid)

# Creating a new table of data for each county
# Variables:
#   total_cases - number of cases in the county
#   total_death - number of deaths in the county
#   total_hospital - number of hopsitalized cases in the county
#   fatality_rate - how many people died out of the number of cases in the county
covid_grouped_by_county <- covid %>% 
  group_by(County) %>% 
  mutate(
    total_cases = sum(Case.Count),
    total_death = sum(Death.Count),
    total_hospital = sum(Hospitalized.Count),
    fatality_rate = total_death / total_cases
  ) %>%
  select(County, total_cases, total_death, total_hospital, fatality_rate) %>%
  distinct()

# Basic bar plot of deaths in counties that had deaths ordered from greatest 
# to least
covid_grouped_by_county %>% 
  filter(total_death > 0) %>%
  ggplot(aes(total_death, reorder(County, total_death))) +
    geom_bar(stat = "identity")

#Libby - Basic bar plot of deaths in counties that had deaths ordered from greatest 
# to least, flipped x and y and with color and titles
plot <- covid_grouped_by_county %>% 
  filter(total_death > 0) %>%
  ggplot(aes(y=total_death, x=reorder(County, total_death)))+
  geom_bar(stat = "identity", fill = "steelblue")+ labs( title = "Ohio Covid-19 Deaths By County")+ xlab("County")+ ylab("Total Deaths")

plot <- plot + coord_flip() 
plot + scale_fill_brewer(palette = "Blues")

