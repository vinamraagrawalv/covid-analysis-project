# This is where we should do the analysis on the data and where we should save any 
# graphs to the figs directory.

# This just loads the covid data in to R. It'll be saved as the variable covid which
# is a data.frame class because we defined the data as covid in the wrangle-data.R
# file. Tidyverse is for any changes to the data that need to be made and ggplot is
# for visualization.
library(tidyverse)
library(ggplot2)
load("rdata/covid.rda")