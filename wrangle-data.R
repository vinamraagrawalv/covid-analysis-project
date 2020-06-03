# This file is taking the downloaded csv file and converting it to a R usable file
# called an .rda file. Any data cleaning and/or mutation should be done here.

# Here I'm just saving the .rda file from the .csv file. The tidyverse package is for
# the mutate() function and other functions that are helpful for cleaning
# the data.
library(tidyverse)
covid <- read.csv("data/covid.csv")
save(covid, file = "rdata/covid.rda")