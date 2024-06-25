 
# Install required packages
# tidyverse: A collection of R packages designed for data
# lubridate: A package specifically for working with dates and times
# ggplot: Used for creating graphics and visualizations
# readr:  Used for reading rectangular data, like CSV files.
# dplyr: It provides a grammar for data manipulation, which includes tools for filtering, selecting, grouping, and combining data frames

install.packages("tidyverse")
install.packages("lubridate")
install.packages("ggplot2")
install.packages("readr")
install.packages("dplyr")

# Call the packages
library(tidyverse)  
library(lubridate)  
library(ggplot2)  
library(dplyr)
library(readr)

# The path to your current working directory.
getwd() 

# Assign the path to the variable
work_dir <- "C:/GooglDA/Member_vs_Casual_Riders/CSV"

# Set the working directory to the specified path
setwd(work_dir)

# Verify that the working directory has been set correctly
getwd()

# ---------------------
# STEP 1: COLLECT DATA

# Read the CSV files
q1_2020 <- read_csv("Divvy_Trips_2020_Q1.csv")
q4_2019 <- read_csv("Divvy_Trips_2019_Q4.csv")
q3_2019 <- read_csv("Divvy_Trips_2019_Q3.csv")
q2_2019 <- read_csv("Divvy_Trips_2019_Q2.csv")

# ---------------------
# STEP 2: WRANGLE DATA AND COMBINE INTO A SINGLE FILE

# Compare column names
colnames(q1_2020)
colnames(q2_2019)
colnames(q3_2019)
colnames(q4_2019)

# Remove extra columns
q1_2020 <- q1_2020 %>% select(-c(start_lat, start_lng, end_lat, end_lng))
q4_2019 <- q4_2019 %>% select(-c(birthyear, gender, tripduration))
q3_2019 <- q3_2019 %>% select(-c(birthyear, gender, tripduration))
q2_2019 <- q2_2019 %>% select(-c("01 - Rental Details Duration In Seconds Uncapped", "Member Gender", "05 - Member Details Member Birthday Year"))

# Rename columns to match q1_2020
q4_2019 <- rename(q4_2019,
                  ride_id = trip_id,
                  rideable_type = bikeid,
                  started_at = start_time,
                  ended_at = end_time,
                  start_station_name = from_station_name,
                  start_station_id = from_station_id,
                  end_station_name = to_station_name,
                  end_station_id = to_station_id,
                  member_casual = usertype)

q3_2019 <- rename(q3_2019,
                  ride_id = trip_id,
                  rideable_type = bikeid,
                  started_at = start_time,
                  ended_at = end_time,
                  start_station_name = from_station_name,
                  start_station_id = from_station_id,
                  end_station_name = to_station_name,
                  end_station_id = to_station_id,
                  member_casual = usertype)

q2_2019 <- rename(q2_2019,
                  ride_id = "01 - Rental Details Rental ID",
                  rideable_type = "01 - Rental Details Bike ID",
                  started_at = "01 - Rental Details Local Start Time",
                  ended_at = "01 - Rental Details Local End Time",
                  start_station_name = "03 - Rental Start Station Name",
                  start_station_id = "03 - Rental Start Station ID",
                  end_station_name = "02 - Rental End Station Name",
                  end_station_id = "02 - Rental End Station ID",
                  member_casual = "User Type")

# Inspect the data frames
str(q1_2020)
str(q4_2019)
str(q3_2019)
str(q2_2019)

# Convert ride_id and rideable_type to character
q4_2019 <- mutate(q4_2019, ride_id = as.character(ride_id), rideable_type = as.character(rideable_type))
q3_2019 <- mutate(q3_2019, ride_id = as.character(ride_id), rideable_type = as.character(rideable_type))
q2_2019 <- mutate(q2_2019, ride_id = as.character(ride_id), rideable_type = as.character(rideable_type))

# Merge quarterly data frames into one big data frame
all_trips <- bind_rows(q2_2019, q3_2019, q4_2019, q1_2020)

# Verify the combined data frame
glimpse(all_trips)

# Remove quarterly data frames to clear up space
rm(q1_2020, q2_2019, q3_2019, q4_2019)

# ---------------------
# STEP 3: CLEAN UP AND ADD DATA TO PREPARE FOR ANALYSIS
# Inspect the new table that has been created
colnames(all_trips)  # List of column names
nrow(all_trips)  # Number of rows in the data frame
dim(all_trips)  # Dimensions of the data frame
head(all_trips)  # See the first 6 rows of the data frame
tail(all_trips)  # See the last 6 rows of the data frame
str(all_trips)  # List of columns and data types
summary(all_trips)  # Statistical summary of the data

# Fix data issues
# (1) Consolidate member_casual labels
table(all_trips$member_casual)

# Reassign to the desired values
all_trips <- all_trips %>%
  mutate(member_casual = recode(member_casual, 
                                "Subscriber" = "member", 
                                "Customer" = "casual"))

# Check reassignment
table(all_trips$member_casual)

# (2) Add date-related columns
all_trips$date <- as.Date(all_trips$started_at)
all_trips$month <- format(as.Date(all_trips$date), "%m")
all_trips$day <- format(as.Date(all_trips$date), "%d")
all_trips$year <- format(as.Date(all_trips$date), "%Y")
all_trips$day_of_week <- format(as.Date(all_trips$date), "%A")

# (3) Convert started_at and ended_at to datetime
all_trips <- all_trips %>%
  mutate(started_at = ymd_hms(started_at),
         ended_at = ymd_hms(ended_at))

# (4) Calculate ride_length in minutes
all_trips$ride_length <- difftime(all_trips$ended_at, all_trips$started_at, units = "mins")

# Inspect the structure of the columns
str(all_trips)

# Clean the data
# Check number of rows before cleaning data
nrow(all_trips)

# Remove rows with NA values
all_trips <- na.omit(all_trips)

# Remove duplicate rows
all_trips <- distinct(all_trips)

# Remove rows where ride_length is 0 or negative
all_trips <- all_trips[!(all_trips$ride_length <= 0),]

# Check number of rows after cleaning data
nrow(all_trips) 

# Load necessary packages
library(tidyverse)
library(lubridate)

# Descriptive analysis on ride_length (all figures in minutes)
mean(all_trips$ride_length)   # Straight average (total ride length / rides)
median(all_trips$ride_length) # Midpoint number in the ascending array of ride lengths
max(all_trips$ride_length)    # Longest ride
min(all_trips$ride_length)    # Shortest ride

# Condense the four lines above to one line using summary() on the specific attribute
summary(all_trips$ride_length)

# See how many observations fall under each usertype
table(all_trips$member_casual)

# Compare members and casual users
aggregate(ride_length ~ member_casual, data = all_trips, FUN = mean)
aggregate(ride_length ~ member_casual, data = all_trips, FUN = median)
aggregate(ride_length ~ member_casual, data = all_trips, FUN = max)
aggregate(ride_length ~ member_casual, data = all_trips, FUN = min)

# See the average ride time by each day for members vs casual users
aggregate(ride_length ~ member_casual + day_of_week, data = all_trips, FUN = mean)

# Fix the order of the days of the week
all_trips$day_of_week <- ordered(all_trips$day_of_week, levels=c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"))

# Run the average ride time by each day for members vs casual users again
aggregate(ride_length ~ member_casual + day_of_week, data = all_trips, FUN = mean)

# Analyze ridership data by type and weekday
all_trips %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>%  # Create weekday field using wday()
  group_by(member_casual, weekday) %>%  # Group by usertype and weekday
  summarise(number_of_rides = n(),        # Calculate the number of rides and average duration
            average_duration = mean(ride_length)) %>%  # Calculate the average duration
  arrange(member_casual, weekday)  # Arrange by usertype and weekday

# Number of rides per month by user type
all_trips %>% 
  mutate(month = month.abb[as.numeric(month)]) %>%  # Convert month number to month abbreviation
  mutate(month = factor(month, levels = month.abb)) %>%  # Convert month abbreviation to a factor with levels in order
  group_by(member_casual, month) %>%  # Group by usertype and month
  summarise(Number_of_Ride = n()) %>%  # Summarize the number of rides
  print(n = 24)  # Print the result with 24 rows

# Visualization of the number of rides by rider type
all_trips %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>%  # Create weekday field using wday()
  group_by(member_casual, weekday) %>%  # Group by usertype and weekday
  summarise(number_of_rides = n(),       # Calculate the number of rides
            average_duration = mean(ride_length)) %>%  # Calculate the average duration
  arrange(member_casual, weekday) %>%  # Arrange by usertype and weekday
  ggplot(aes(x = weekday, y = number_of_rides, fill = member_casual)) +  # Create ggplot
  geom_col(position = "dodge")  # Create a bar plot with dodged bars

# Visualization of the average ride duration
all_trips %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>%  # Create weekday field using wday()
  group_by(member_casual, weekday) %>%  # Group by usertype and weekday
  summarise(number_of_rides = n(),       # Calculate the number of rides
            average_duration = mean(ride_length)) %>%  # Calculate the average duration
  arrange(member_casual, weekday) %>%  # Arrange by usertype and weekday
  ggplot(aes(x = weekday, y = average_duration, fill = member_casual)) +  # Create ggplot
  geom_col(position = "dodge")  # Create a bar plot with dodged bars

# Visualization for the number of rides per month
all_trips %>% 
  mutate(month = month.abb[as.numeric(month)]) %>%  # Convert month number to month abbreviation
  mutate(month = factor(month, levels = month.abb)) %>%  # Convert month abbreviation to a factor with levels in order
  group_by(member_casual, month) %>%  # Group by usertype and month
  summarise(Number_of_Ride = n()) %>%  # Summarize the number of rides
  ggplot(aes(x = month, y = Number_of_Ride, fill = member_casual)) +  # Create ggplot
  geom_col(position = "dodge")  # Create a bar plot with dodged bars

# STEP 5: EXPORT CSV FILE
# Aggregate average ride length by member_casual and day_of_week
counts <- all_trips %>% 
  group_by(member_casual, day_of_week) %>% 
  summarise(avg_ride_length = mean(ride_length))

# Export to CSV
write.csv(counts, file = '/cloud/project/Google_Data_Analytics/Member_vs_Casual_Riders/CSV/avg_ride_length.csv', row.names = FALSE)

# Confirmation message
cat("Summary file exported successfully!\n")
