Covid Analysis Project
Authors: Vinamra Agrawal, Camryn Craig, Libby Mannix, & Brittany Shine
Date: 06/03/2020

This project is an analysis of the publically available COVID-19 data for Ohio from the Ohio Department of Health. We combine this data with other publically available datasets.

Data used is available at: 
  covid - https://coronavirus.ohio.gov/static/COVIDSummaryData.csv

File Information:
  download-data.R - downloads csv files to data directory
  wrangle-data.R - creates a derived dataset and saves as an R object in rdata directory
  analysis.R - the analysis of the data; creates figures that are saved in the figs directory
  population-data-wrangling-function.R - wrangling function for the population data set. The wrangling was put into this file separate from the wrangle-data.R file because the data set required quite a bit of wrangling to work.
