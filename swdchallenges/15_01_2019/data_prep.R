#Anthony Pena 
#Jan 12, 2019 
#Combine ACS data for years 2006-2017 and prepare for data viz 

#load relevant packages for data prep
library(dplyr)
library(tidyr)

#relevant CSV files are already in current working directory
files <- list.files(pattern = '.csv')
my_df <- do.call(rbind, lapply(files, read.csv))

#metadata stored in a separate file
annotations <- read_csv('~/ACS_17_1YR_B08303_metadata.csv')
col_headers <- as.vector(t(annotations$Id))

#remove column with all NA's in the data files but not present in the metadata file
my_df <- dplyr::select(my_df, -GEO.id2)
colnames(my_df) <- col_headers

#manually add year column as not provided in the data directly
my_df <- mutate(my_df, year=seq(2006,2017,1))

#extract columns with estimates only (optional)
my_df_subset <- my_df[,seq(1,29,2)]

#trim white space from column names (optional)
colnames(my_df_subset) <- gsub('Estimate; Total: - ','',colnames(my_df_subset)) %>%
  gsub(' ','_',.)

#perform data transformation and write to CSV
my_df_gathered <- gather(my_df_subset, commute_time, num_ppl,-c(Id2,'Estimate;_Total:',year))
write.csv(my_df_gathered,'2006_2017_Census_ASC_Survey.csv')
