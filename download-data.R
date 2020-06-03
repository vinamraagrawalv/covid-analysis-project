# This file is for downloading data from sites and putting them into the data directory

# Set url to download data from and then put that data into a directory called data.
#
# The example here is for covid data. I don't have a url yet but if you find a data 
# that you think is good, feel free to add it here or use this template.
url <- 
dest_file_covid <- "data/covid.csv"
download.file(url, destfile = dest_file_covid)