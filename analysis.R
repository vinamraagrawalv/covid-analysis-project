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

# Create a data frame table of covid cases grouped by age group
covid_grouped_by_age <- covid %>% 
  group_by(Age.Range) %>% 
  mutate(
    total_cases = sum(Case.Count),
    total_death = sum(Death.Count),
    total_hospital = sum(Hospitalized.Count),
    fatality_rate = total_death / total_cases
  ) %>%
  select(Age.Range, total_cases, total_death, total_hospital, fatality_rate) %>%
  distinct()

# Creates bar plot of cases by age group colored by type of cases with labels
# for the specific number of cases for each type.
covid_grouped_by_age %>% 
  filter(Age.Range != "Unknown") %>%
  mutate(not_death = total_cases - total_death) %>%
  gather(category, value, total_death, not_death) %>%
  mutate(lab_ypos = cumsum(value) + 300) %>%
  ggplot(aes(x = Age.Range, y = value)) +
    geom_col(aes(fill = category))+
    labs(y = "Total Deaths", 
         x = "Age", 
         title = "Ohio Covid-19 Cases By Age") +
    geom_text(aes(y = lab_ypos, 
                  label = value, 
                  group = category), 
                  color = "black") +
    scale_fill_discrete(name = "Case Type", 
                        label = c("Recovered Cases", "Deaths"))

# Saves barplot of cases by age group to figs directory
ggsave("figs/age_case_type_barplot.png")

# Libby - Basic bar plot of deaths in counties that had deaths ordered from greatest 
# to least, flipped x and y and with color and titles
# Vinamra - Added fill argument to aes() for region color fill and labs() for 
# labels since they weren't appearing for me with xlabs, ylabs, and main arguments
county_death_barplot <- covid_grouped_by_county %>% 
  filter(total_death > 10) %>%
  ggplot(aes(y=total_death, x=reorder(County, total_death), fill = region)) +
    geom_bar(stat = "identity") +
    labs(y = "Total Deaths", 
         x = "County", 
         title = "Ohio Covid-19 Deaths By County", 
         caption = "*Counties not shown have less than 10 total deaths") +
    coord_flip() + 
    scale_fill_brewer(palette="Paired")

# Saving a .png of the total death barplot to the figs directory
ggsave("figs/county_death_barplot.png")
    
county_death_barplot

# Boxplot of the fatality rates separated by region. Red line shows cut off for
# fatality rates that are considered too high and may be an indication of too
# little testing.
county_fatality_boxplot <- covid_grouped_by_county %>% 
  filter(fatality_rate > 0) %>%
  ggplot(aes(x = reorder(region, fatality_rate), y = fatality_rate)) +
  geom_boxplot() +
  geom_point(aes(col = region)) +
  labs(y = "Fatality Rate", x = "Region", 
       title = "Ohio Covid-19 Fatality Rate By Region",
       caption = "*Only counties with a fatality rate greater than 0 are shown") +
  geom_hline(color = "red", yintercept = .1) + 
  scale_colour_brewer(palette="Paired")

# Saving a .png of the boxplot of fatality rates to the figs directory
ggsave("figs/county_fatality_boxplot.png")

county_fatality_boxplot
