# This file is for downloading data from sites and putting them into the data directory

# Set url to download data from and then put that data into a directory called data.
#
# The example here is for covid data. If you find a data 
# that you think is good, feel free to add it here or use this template.
url <- "https://coronavirus.ohio.gov/static/COVIDSummaryData.csv"
dest_file_covid <- "data/covid.csv"
download.file(url, destfile = dest_file_covid)
