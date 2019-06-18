########################################
# load libraries
########################################

# load some packages that we'll need
library(tidyverse)
library(scales)

# be picky about white backgrounds on our plots
theme_set(theme_bw())

# load RData file output by load_trips.R
load('trips.RData')


########################################
# plot trip data
########################################

# plot the distribution of trip times across all rides
ggplot(data = trips, mapping = aes(x = tripduration, fill = "red")) +
  geom_histogram() +
  scale_x_log10()
# plot the distribution of trip times by rider type
trips %>% filter(tripduration/60 < 240) %>% 
  ggplot(mapping = aes(x = tripduration, fill = usertype)) + 
  geom_histogram()+
  facet_wrap(~ usertype) + 
  scale_x_log10() 
# plot the total number of trips over each day
trips %>% group_by(ymd) %>% 
  summarize(count = n()) %>%
  ggplot(mapping = aes (x = ymd, y = count, color = "red")) +
  geom_point()
# plot the total number of trips (on the y axis) by age (on the x axis) and gender (indicated with color)
trips %>% group_by(birth_year, gender) %>% 
  summarize(num_trips = n()) %>%
  ggplot(mapping = aes (x = 2014 - birth_year, y = num_trips, color = gender)) +
  geom_line()
# plot the ratio of male to female trips (on the y axis) by age (on the x axis)
trips %>% group_by(birth_year, gender) %>% 
  summarize(num_trips = n()) %>% spread(gender, num_trips) %>%
  mutate(ratio = Male / Female) %>%
  ggplot(mapping = aes (x = 2014 - birth_year, y = ratio, color = "grey70")) +
  geom_line() + 
  xlim(c(18,80))
           
# hint: use the spread() function to reshape things to make it easier to compute this ratio

########################################
# plot weather data
########################################
# plot the minimum temperature (on the y axis) over each day (on the x axis)
weather %>% select(tmin, ymd) %>% 
  ggplot(mapping = aes (x = ymd, y = tmin)) +
  geom_line()
# plot the minimum temperature and maximum temperature (on the y axis, with different colors) over each day (on the x axis)
# hint: try using the gather() function for this to reshape things before plotting
weather %>% gather(key = 'min_max', value = 'temp', tmin, tmax) %>% 
  ggplot(aes(x = ymd, y = temp, color = min_max))+
  geom_point()
  
########################################
# plot trip and weather data
########################################

# join trips and weather
trips_with_weather <- inner_join(trips, weather, by="ymd")

# plot the number of trips as a function of the minimum temperature, where each point represents a day
# you'll need to summarize the trips and join to the weather data to do this
trips_with_weather %>% group_by(tmin, ymd) %>% 
  summarize(num_trips = n()) %>%
  ggplot(aes(x = tmin, y = num_trips)) +
  geom_point()

# repeat this, splitting results by whether there was substantial precipitation or not
# you'll need to decide what constitutes "substantial precipitation" and create a new T/F column to indicate this
trips_with_weather %>% 
  group_by(ymd) %>% 
  summarize(num_trips = n(), prcp = mean(prcp), min_temp = mean(tmin)) %>% 
  mutate(rain = prcp > 0.3 & TRUE) %>% 
  ggplot(mapping = aes(x = min_temp, y = num_trips, color = rain)) +
  geom_point() +  
  scale_colour_brewer(palette="Set1") + 
  geom_smooth(method = "lm")

# add a smoothed fit on top of the previous plot, using geom_smooth

# compute the average number of trips and standard deviation in number of trips by hour of the day
# hint: use the hour() function from the lubridate package
trips %>% mutate(hour = hour(starttime)) %>% 
  group_by(hour, ymd) %>% 
  summarize(num_trips = n()) %>%
  group_by(hour) %>% 
  summarize(st_dv = sd(num_trips), mean = mean(num_trips)) %>%
  ggplot(mapping = aes(x = hour, y = mean)) + 
  geom_ribbon(aes(ymin = mean - st_dv, ymax = mean + st_dv, fill = "grey70"))+
  geom_point()

# plot the above

# repeat this, but now split the results by day of the week (Monday, Tuesday, ...) or weekday vs. weekend days
# hint: use the wday() function from the lubridate package
trips %>% mutate(hour = hour(starttime), day_of_week = wday(starttime)) %>% 
  group_by(hour, ymd, day_of_week) %>% 
  summarize(num_trips = n()) %>%
  group_by(hour, day_of_week) %>% 
  summarize(st_dv = sd(num_trips), mean = mean(num_trips)) %>%
  ggplot(mapping = aes(x = hour, y = mean)) + 
  geom_ribbon(aes(ymin = mean - st_dv, ymax = mean + st_dv, fill = "grey70"))+
  geom_line() + facet_wrap(~day_of_week)