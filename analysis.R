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

northwest_regions <- c("Allen", "Crawford", "Defiance", "Erie", "Fulton", 
                       "Hancock", "Hardin", "Henry", "Huron", "Lucas", "Morrow", 
                       "Ottawa", "Paulding", "Putnam", "Sandusky", "Seneca", 
                       "Williams", "Wood", "Wyandot", "Marion", "Van Wert")

northeast_regions <- c("Ashland", "Ashtabula", "Columbiana", "Cuyahoga", "Geauga",
                       "Lake", "Lorain", "Mahoning", "Medina", "Portage", 
                       "Richland", "Stark", "Summit", "Trumbull", "Wayne")

southwest_regions <- c("Adams", "Auglaize", "Brown", "Butler", "Champaign", 
                       "Clark", "Clermont", "Clinton", "Darke", "Fayette", 
                       "Gallia", "Greene", "Hamilton", "Highland", "Logan", 
                       "Mercer", "Miami", "Montgomery", "Preble", "Shelby", 
                       "Warren")

southeast_regions <- c("Athens", "Belmont", "Carroll", "Coshocton", "Guernsey", 
                       "Harrison", "Hocking", "Holmes", "Jackson", "Jefferson", 
                       "Knox", "Lawrence", "Meigs", "Monroe", "Morgan", 
                       "Muskingum", "Noble", "Perry", "Pickaway", "Pike", "Ross", 
                       "Scioto", "Tuscarawas", "Vinton", "Washington")

central_regions <- c("Delaware", "Fairfield", "Franklin", "Licking", "Madison", 
                     "Union")

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
    region = ifelse(County %in% northwest_regions, "NW", 
             ifelse(County %in% northeast_regions, "NE", 
             ifelse(County %in% southwest_regions, "SW", 
             ifelse(County %in% southeast_regions, "SE", 
             ifelse(County %in% central_regions, "CE", NA))))),
    fatality_rate = total_death / total_cases
  ) %>%
  select(County, region, total_cases, total_death, total_hospital, fatality_rate) %>%
  distinct()

# Libby - Basic bar plot of deaths in counties that had deaths ordered from greatest 
# to least, flipped x and y and with color and titles
# Vinamra - Added fill argument to aes() for gradient color fill and labs() for 
# labels since they weren't appearing for me with xlabs, ylabs, and main arguments
plot <- covid_grouped_by_county %>% 
  filter(total_death > 10) %>%
  ggplot(aes(y=total_death, x=reorder(County, total_death), fill = region)) +
    geom_bar(stat = "identity") +
    labs(y = "Total Deaths", x = "County", title = "Ohio Covid-19 Deaths By County", Caption = "*Counties not shown have less than 10 total deaths") +
    coord_flip() + scale_fill_brewer(palette="Paired")
    
plot
