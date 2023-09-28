#!/usr/bin/env Rstudio
install.packages("readxl", repos = "http://cran.us.r-project.org") # install this package to be able to read in excel files 
install.packages("dplyr", repos = "http://cran.us.r-project.org") # install dplyr package to be able to analyze data efficiently 
install.packages("stringr", repos = "http://cran.us.r-project.org") # Install stringr
install.packages("rebus", repos = "http://cran.us.r-project.org") # install rebus 
install.packages("writexl", repos = "http://cran.us.r-project.org") # Install package to write out data to excel 
library(rebus) # load in rebus package 
library(stringr) # load stringr 
library(readxl) # run to load in excel file reading package 
library(dplyr) # load in the dplyr package 
library(writexl) # load write out excel package 

# read in the excel file (ensure that the file is within the same folder as the code) and set to skip the first 4 rows which is the title and extra stuff
mydata <- read_excel("RICAP Y Maze Scoring Sheet copy.xlsx", skip = 4, ) 

# Dropping the date of behavior, date of scoring, initials, and notes columns 
df <- select(mydata, -c(2,4, 5, 6))

# count the total entries 
df$`Total Entries` <- str_length(df$`Arm entries`)

# count the total doubles 
df$`Total Doubles` <- str_count(df$`Arm entries`,
         pattern = capture(UPPER) %R% REF1)

# Calculate the doubles Index 
df$`Doubles Index (%)` <- round(df$`Total Doubles`/(df$`Total Entries` - 1) *100)

# Calculate the total alternations 
# Encode for every possible alternation 
v1 <- 'ABC'
v2 <- 'ACB'
v3 <- 'BCA'
v4 <- 'BAC'
v5 <- 'CBA'
v6 <- 'CAB'
# Find the count of each variation for each string row 
v1_count <- str_count(df$`Arm entries`, pattern = (v1))
v2_count <- str_count(df$`Arm entries`, pattern = (v2))
v3_count <- str_count(df$`Arm entries`, pattern = (v3))
v4_count <- str_count(df$`Arm entries`, pattern = (v4))
v5_count <- str_count(df$`Arm entries`, pattern = (v5))
v6_count <- str_count(df$`Arm entries`, pattern = (v6))
# sum up the counts for each letter variation to new column Total Alternations. 
df$`Total Alternations` <- str_count(df$`Arm entries`, pattern = (v1)) + str_count(df$`Arm entries`, pattern = (v2)) + str_count(df$`Arm entries`, pattern = (v3)) + str_count(df$`Arm entries`, pattern = (v4)) + str_count(df$`Arm entries`, pattern = (v5)) + str_count(df$`Arm entries`, pattern = (v6))

# Calculate Alternations Index 
df$`Alternations Index (%)` <- round(df$`Total Alternations`/(df$`Total Entries` - 2) *100)

# Write out table to excel 
write_xlsx(df, '/Users/abigailparakoyi/Desktop/LabWork/Mikey Code/test2') # Ensure to change last word for title of excel sheet 


