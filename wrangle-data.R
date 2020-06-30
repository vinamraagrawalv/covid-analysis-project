# This file is taking the downloaded csv file and converting it to a R usable file
# called an .rda file. Any data cleaning and/or wrangling should be done here.

# Here I'm just saving the .rda file from the .csv file. The tidyverse package is for
# the mutate() function and other functions that are helpful for cleaning
# the data.
library(tidyverse)
covid <- read.csv("data/covid.csv", stringsAsFactors = FALSE)

# Deleting calculated row at the end of the data (totals)
covid <- covid[-nrow(covid),]

# Fixing broken column name for counties
names(covid)[names(covid) == "ï..County"] <- "County"

# Converting numeric attributes from character class (caused by read.csv function)
# to numeric values.
covid$Case.Count <- as.numeric(covid$Case.Count)
covid$Death.Count <- as.numeric(covid$Death.Count)
covid$Hospitalized.Count <- as.numeric(covid$Hospitalized.Count)

save(covid, file = "rdata/covid.rda")

# Run population_data_wrangling_function.R file before this code to get the 
# wrangle function for the population data.
population <- read.csv("data/population.csv", stringsAsFactors = FALSE)
population <- wrangle_pop(population)
