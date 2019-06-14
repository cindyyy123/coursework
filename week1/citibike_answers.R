library(tidyverse)
library(lubridate)

########################################
# READ AND TRANSFORM THE DATA
########################################

# read one month of data
trips <- read_csv('201402-citibike-tripdata.csv')

# replace spaces in column names with underscores
names(trips) <- gsub(' ', '_', names(trips))

# convert dates strings to dates
# trips <- mutate(trips, starttime = mdy_hms(starttime), stoptime = mdy_hms(stoptime))

# recode gender as a factor 0->"Unknown", 1->"Male", 2->"Female"
trips <- mutate(trips, gender = factor(gender, levels=c(0,1,2), labels = c("Unknown","Male","Female")))


########################################
# YOUR SOLUTIONS BELOW
########################################

# count the number of trips (= rows in the data frame)
X201402_citibike_tripdata %>% summarize(num_of_trips = n())
# find the earliest and latest birth years (see help for max and min to deal with NAs)
trips %>% 
  trips1 <- mutate(X201402_citibike_tripdata, birth_year = as.numeric(birth_year))
 summarize(trips1, min= min(birth_year, na.rm = TRUE), max= max(birth_year, na.rm = TRUE))         
# use filter and grepl to find all trips that either start or end on broadway
 trips %>% 
   filter(X201402_citibike_tripdata, grepl('Broadway', start_station_name) | grepl('Broadway', end_station_name))
# do the same, but find all trips that both start and end on broadway
 trips %>% 
   filter(X201402_citibike_tripdata, grepl('Broadway', start_station_name) & grepl('Broadway', end_station_name))

# find all unique station names
 trips %>% 
   select(start_station_name) %>% unique()
# count the number of trips by gender, the average trip time by gender, and the standard deviation in trip time by gender
 trips %>% 
   group_by(gender) %>% 
   summarize(num_of_trips = n(), avg_trip_time = mean(tripduration), standard_deviation = sd(tripduration))
# do this all at once, by using summarize() with multiple arguments

# find the 10 most frequent station-to-station trips
trips %>%
  group_by(start_station_name, end_station_name)%>%
  summarize(num_of_trips = n()) %>%
  arrange(desc(num_of_trips)) %>% head(10)
# find the top 3 end stations for trips starting from each start station
trips %>% group_by(start_station_name) %>% 
  select(end_station_name) %>% head()
# find the top 3 most common station-to-station trips by gender
trips %>% group_by(gender) %>% 
  select(start_station_name, end_station_name) %>% head(3)
# find the day with the most trips
trips %>%  mutate(new_column = as.Date(starttime))%>% 
  group_by(new_column) %>% summarize(num_of_trips = n())%>%
  arrange(desc(num_of_trips)) %>% head(1)
# tip: first add a column for year/month/day without time of day (use as.Date or floor_date from the lubridate package)

# compute the average number of trips taken during each of the 24 hours of the day across the entire month
trips %>% mutate(date1 = as.Date(starttime) , hour1 = hour(starttime)) %>% 
  group_by(date1 , hour1) %>%
  summarize(num_of_trips = n()) %>% group_by(hour1) %>% 
  summarize(mean(num_of_trips)) 
  
# what time(s) of day tend to be peak hour(s)?
trips %>% 
  mutate(date1 = as.Date(starttime) , hour1 = hour(starttime)) %>% 
  group_by(date1 , hour1) %>%
  summarize(num_of_trips = n()) %>% group_by(hour1) %>% 
  summarize(mean = mean(num_of_trips)) %>% 
  arrange(desc(mean)) 
