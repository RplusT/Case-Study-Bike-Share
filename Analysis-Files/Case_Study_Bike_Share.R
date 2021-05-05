# installing and loading packages ----

install.packages("tidyverse")
library(tidyverse)
library(ggplot2)
library(lubridate)
library(here)
library(readr)
library(dplyr)
setwd("/Users/roberttiong/Documents/Data Science/Case Study - Bike Share")

# uploading dataset ----
yearly_tripdata <- read_csv("202004-202103-divvy-tripdata_v20210428.csv")

# clean dataset ----
yearly_tripdata$date <- as.Date(yearly_tripdata$started_at)
yearly_tripdata$day_of_week <- as.factor(yearly_tripdata$day_of_week)
yearly_tripdata$month <- as.factor(yearly_tripdata$month)
yearly_tripdata$hour_of_day <- as.factor(format(yearly_tripdata$started_at,"%H"))

levels(yearly_tripdata$day_of_week) <- c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday")
levels(yearly_tripdata$month) <- c ("January", "February", "March", "April", "May", "June", "July", "August", "September",
                                    "October", "November", "December")

# inspect dataset
colnames(yearly_tripdata)
nrow(yearly_tripdata)
str(yearly_tripdata)
summary(yearly_tripdata)

# remove rides with negative duration
yearly_tripdata_v2 <- yearly_tripdata[!(yearly_tripdata$duration<0),]

# descriptive analysis on duration; in seconds ----

mean(yearly_tripdata_v2$duration)
## 1,677 seconds or 27 minutes and 57 seconds

max(yearly_tripdata_v2$duration)
## 3,523,202 seconds or 40 days and 18 hours

min(yearly_tripdata_v2$duration)
## 0


# comparing members and casual riders ----

# average ride duration
aggregate(yearly_tripdata_v2$duration ~ yearly_tripdata_v2$member_casual, FUN = mean)
## member = 16 minutes and 6 seconds
## casual = 44 minutes and 58 seconds

# max ride duration
aggregate(yearly_tripdata_v2$duration ~ yearly_tripdata_v2$member_casual, FUN = max)
## member = 40 days and 18 hours
## casual = 38 days and 16 hours

# minimum ride duration
aggregate(yearly_tripdata_v2$duration ~ yearly_tripdata_v2$member_casual, FUN = min)
## member = 0
## casual = 0

# daily average ride duration comparison
aggregate(yearly_tripdata_v2$duration ~ yearly_tripdata_v2$day_of_week, FUN = mean)
aggregate(yearly_tripdata_v2$duration ~ yearly_tripdata_v2$day_of_week + yearly_tripdata_v2$member_casual, FUN = mean)
## rides by members are really shorter on average

# average ride duration plot
yearly_tripdata_v2 %>%
  group_by(member_casual) %>%
  summarise(average_duration = mean(duration)/60) %>%
  arrange(member_casual) %>%
  ggplot(aes(x = member_casual, y = average_duration)) +
  geom_col(aes(fill = member_casual)) +
  xlab("Rider Type") +
  ylab("Average Ride Duration (mins)") +
  labs(title = "Comparison of ride duration") +
  theme(plot.title = element_text(face = "bold"), legend.position = "none")
  

# average number of rides and average ride duration on a daily basis
yearly_tripdata_v2 %>%
  group_by(member_casual, day_of_week) %>%
  summarise(number_of_rides = n(),
            average_duration = mean(duration)) %>%
  arrange(member_casual, day_of_week)

## plotting number of rides
yearly_tripdata_v2 %>%
  group_by(member_casual, day_of_week) %>%
  summarise(number_of_rides = n(),
            average_duration = mean(duration)) %>%
  arrange(member_casual, day_of_week) %>%
  ggplot(aes(x = day_of_week, y = number_of_rides, fill = member_casual)) +
  geom_col(position = "dodge") +
  xlab("Day") +
  ylab("No. of Rides") +
  labs(fill = "Rider Type", title = "No. of rides per day ", 
       subtitle = "Casual v Member") +
  theme(plot.title = element_text(face = "bold"))

## members ride a lot more, with the number of rides per day being consistent
## casual riders ride most often on the weekend, especially saturdays
## casual rides are just around 3/4 of the number of rides by members on weekdays

## plotting average duration
yearly_tripdata_v2 %>%
  group_by(member_casual, day_of_week) %>%
  summarise(number_of_rides = n(),
            average_duration = mean(duration)/60) %>%
  arrange(member_casual, day_of_week) %>%
  ggplot(aes(x = day_of_week, y = average_duration, fill = member_casual)) +
  geom_col(position = "dodge") +
  xlab("Day") +
  ylab("Average Ride Duration (mins)") +
  labs(fill = "Rider Type", title = "Daily ride duration ", 
       subtitle = "Casual v Member") +
  theme(plot.title = element_text(face = "bold"))


## member rides are significantly shorter than casual rides, less than half the duration, regardless of day

# average number of rides and average ride duration based on time of day
yearly_tripdata_v2 %>%
  group_by(member_casual, hour_of_day) %>%
  summarise(number_of_rides = n(),
            average_duration = mean(duration)) %>%
  arrange(member_casual, hour_of_day)

## plotting number of rides
### Casual
yearly_tripdata_v2 %>%
  group_by(member_casual, hour_of_day) %>%
  summarise(number_of_rides = n(),
            average_duration = mean(duration)) %>%
  filter(member_casual == "casual") %>%
  arrange(member_casual, hour_of_day) %>%
  ggplot(aes(x = hour_of_day, y = number_of_rides, fill = member_casual)) +
  geom_col() +
  xlab("Time of Day") +
  ylab("No. of Rides") + 
  labs(title = "Casual rides throughout the day", subtitle = "Based on time of day") +
  theme(legend.position = "none", plot.title = element_text(face = "bold"))

### Member
yearly_tripdata_v2 %>%
  group_by(member_casual, hour_of_day) %>%
  summarise(number_of_rides = n(),
            average_duration = mean(duration)) %>%
  filter(member_casual == "member") %>%
  arrange(member_casual, hour_of_day) %>%
  ggplot(aes(x = hour_of_day, y = number_of_rides)) +
  geom_col(fill = "#01bfc4") +
  xlab("Time of Day") +
  ylab("No. of Rides") + 
  labs(title = "Member rides throughout the day", subtitle = "Based on time of day") +
  theme(legend.position = "none", plot.title = element_text(face = "bold"))
  
## casual riders ride a lot more after lunch or 12nn, with the highest frequency during 4-6pm
## while members also ride the most around 4-6pm, they also do a lot of riding during the morning, up until mid-afternoon
## members' have a more normal distribution of rides throughout the day compared to casual riders

## plotting duration of rides
yearly_tripdata_v2 %>%
  group_by(member_casual, hour_of_day) %>%
  summarise(number_of_rides = n(),
            average_duration = mean(duration)/60) %>%
  arrange(member_casual, hour_of_day) %>%
  ggplot(aes(x = hour_of_day, y = average_duration, fill = member_casual)) +
  geom_col(position = "dodge") +
  xlab("Time of Day") +
  ylab("Average Ride Duration (mins)") +
  labs(fill = "Rider Type", title = "Ride duration throughout the day", 
       subtitle = "Casual v Member") +
  theme(plot.title = element_text(face = "bold"))

## on average, casual riders ride 30-60 minutes but then this spikes to 1-2 hour rides around midnight to early morning
## members meanwhile maintain their average ride length of 16 minutes regardless of the time
## this could probably mean that rides by members are planned or routinary, perhaps mostly for commuting


# average number of rides and average ride duration on a monthly basis
yearly_tripdata_v2 %>%
  group_by(member_casual, month) %>%
  summarise(number_of_rides = n(),
            average_duration = mean(duration)) %>%
  arrange(member_casual, month)

## plotting number of rides
yearly_tripdata_v2 %>%
  group_by(member_casual, month) %>%
  summarise(number_of_rides = n(),
            average_duration = mean(duration)) %>%
  arrange(member_casual, month) %>%
  ggplot(aes(x = month, y = number_of_rides, fill = member_casual)) +
  geom_col(position = "dodge") +
  xlab("Month") +
  ylab("No. of Rides") +
  labs(fill = "Rider Type", title = "Riding Seasonality", 
       subtitle = "Casual v Member") +
  theme(plot.title = element_text(face = "bold"), axis.text.x = element_text(angle = 45))
## in terms of seasonality, as expected most of the riding occurs in the summer (US-based)
## especially with casual riders as they mostly ride bikes for leisure, perfect for the summer


# start station analysis by rider type ----
casual_start_station <- yearly_tripdata_v2 %>%
  group_by(start_station_name, member_casual) %>%
  summarise(number_of_rides = n()) %>%
  filter(start_station_name != "NA") %>%
  filter(member_casual == "casual") %>%
  rename(casual_rides = number_of_rides) %>%
  select(start_station_name, casual_rides)
  
casual_start_station %>% 
  arrange(desc(casual_rides))%>%
  head(10) %>%
  ggplot(aes(x = reorder(start_station_name, casual_rides), y = casual_rides)) +
  geom_col(fill = "#f8756d") +
  coord_flip() + 
  xlab("Station Name") +
  ylab("No. of Rides") +
  labs(title = "Where do casual riders start their rides?") +
  theme(plot.title = element_text(face = "bold"))

## these stations are near local attractions in the city such as lake michigan and millenium park
## further evidences that casual riders ride bikes mostly for leisure, around tourist attractions
## marketing strategies can revolve around collaboration with local establishments, giving discounts or special passes for newly registered members

member_start_station <- yearly_tripdata_v2 %>%
  group_by(start_station_name, member_casual) %>%
  summarise(number_of_rides = n()) %>%
  filter(start_station_name != "NA") %>%
  filter(member_casual == "member") %>%
  rename(member_rides = number_of_rides) %>%
  select(start_station_name, member_rides)

member_start_station %>% 
  arrange(desc(member_rides))%>%
  head(10) %>%
  ggplot(aes(x = reorder(start_station_name, member_rides), y = member_rides)) +
  geom_col(fill = "#01bfc4") +
  coord_flip() + 
  xlab("Station Name") +
  ylab("No. of Rides") +
  labs(title = "Where do members start their rides?") +
  theme(plot.title = element_text(face = "bold"))

## these stations are more within the city or near residential areas
## further evidence that members use the bikes for commuting

types_start_station <- merge(casual_start_station, member_start_station, by = "start_station_name",
                             all.x = TRUE, all.y = TRUE)
types_start_station$total_rides <- types_start_station$casual_rides + types_start_station$member_rides

types_start_station_long <- gather(types_start_station, "member_casual", "rides", 2:3)

## plotting
### top 10 start stations by rider type
types_start_station_long %>%
  arrange(desc(total_rides)) %>%
  head(20) %>%
  ggplot(aes(x = reorder(start_station_name, total_rides), y = rides, fill = member_casual)) +
  geom_col() +
  coord_flip() + 
  xlab("Station Name") +
  ylab("No. of Rides") +
  labs(title = "Top 10 Stations") +
  scale_fill_discrete(name = "Rider Type", labels = c("Casual", "Member")) +
  theme(plot.title = element_text(face = "bold"))

# end station analysis by rider type ----
casual_end_station <- yearly_tripdata_v2 %>%
  group_by(end_station_name, member_casual) %>%
  summarise(number_of_rides = n()) %>%
  filter(end_station_name != "NA") %>%
  filter(member_casual == "casual") %>%
  rename(casual_rides = number_of_rides) %>%
  select(end_station_name, casual_rides)

casual_end_station %>% 
  arrange(desc(casual_rides))%>%
  head(10) %>%
  ggplot(aes(x = reorder(end_station_name, casual_rides), y = casual_rides)) +
  geom_col(fill = "#f8756d") +
  coord_flip() + 
  xlab("Station Name") +
  ylab("No. of Rides") +
  labs(title = "Where do casual riders end their rides?") +
  theme(plot.title = element_text(face = "bold"))

## casual riders mostly end their rides within the same stations near local attractions
## marketing efforts can really focus on these stations, with a mix of strategies involving the start and end of the trip

member_end_station <- yearly_tripdata_v2 %>%
  group_by(end_station_name, member_casual) %>%
  summarise(number_of_rides = n()) %>%
  filter(end_station_name != "NA") %>%
  filter(member_casual == "member") %>%
  rename(member_rides = number_of_rides) %>%
  select(end_station_name, member_rides)

member_end_station %>% 
  arrange(desc(member_rides))%>%
  head(10) %>%
  ggplot(aes(x = reorder(end_station_name, member_rides), y = member_rides)) +
  geom_col(fill = "#01bfc4") +
  coord_flip() + 
  xlab("Station Name") +
  ylab("No. of Rides") +
  labs(title = "Where do members end their rides?") +
  theme(plot.title = element_text(face = "bold"))

types_end_station <- merge(casual_end_station, member_end_station, by = "end_station_name",
                             all.x = TRUE, all.y = TRUE)
types_end_station$total_rides <- types_end_station$casual_rides + types_end_station$member_rides

types_end_station_long <- gather(types_end_station, "member_casual", "rides", 2:3)

## plotting
### top 10 stations by rider type

types_end_station_long %>%
  arrange(desc(total_rides)) %>%
  head(20) %>%
  ggplot(aes(x = reorder(end_station_name, total_rides), y = rides, fill = member_casual)) +
  geom_col() +
  coord_flip() + 
  xlab("Station Name") +
  ylab("No. of Rides") +
  labs(title = "Top 10 Stations") +
  scale_fill_discrete(name = "Rider Type", labels = c("Casual", "Member")) +
  theme(plot.title = element_text(face = "bold"))

## the top casual rider stations also have members who use them suggesting there is room for conversion efforts involving members...
## .. like referral codes, group rides, etc.
## the same is also true the other way around where there are some casual riders in stations near residential areas suggesting that...
## ... casual riders who use the bikes for commuting can be targets for conversion

# Conclusion ----
### The main difference between casual riders and members is that the former uses the bikes mainly for leisure.
### This is evidenced by the fact that they ride more during the weekends, have longer ride durations, and originate and end their rides near local attractions
### Members meanwhile have a more set routine given their ride durations are more consistent during the week and throughout the day.
### The bike stations they use are near residential areas and the city center suggesting they use the bikes mainly for commuting.

# Recommendations for converting casual riders to members ----
# 1 Marketing efforts should be focused on areas near local attractions. 
# Collaborations with commercial establishments in these areas should be explored.
# Examples: Discount vouchers for new members, a member point system that they can use nearby shops
# 2 In terms of scheduling, the best time to target casual riders are during weekend afternoons, 4-6pm.
# They do most of their riding during this time. To maximize the reach, we should focus our marketing efforts during the summer months,
# ... as riding activity is significantly higher during this time, given the good weather and a better chance to experience the outdoors on a bike.
# 3 While casual riders do mostly frequent local attractions, there is also room for activations...
# ... involving members in stations near residential areas and the city center.
# There are also casual riders who use the bikes for commuting and members are the best positioned to demonstrate the benefits of a full membership.
# Examples can be providing referral discounts to members which they can share to a set number of casual riders. Members can then be compensated with discounted membership rates.
# Weekend group rides can also be a way to activate more members. Members can lead casual riders around the city, with a set route provided by the company.
# Stops along the way can be setup with various marketing activation involving the community or more local shops.

# per station analysis (departures and arrivals) ----
# departures per station
yearly_tripdata_v2 %>%
  group_by(start_station_name) %>%
  summarise(number_of_rides = n()) %>%
  filter(start_station_name != "NA") %>%
  arrange(desc(number_of_rides))

# arrivals per station
yearly_tripdata_v2 %>%
  group_by(end_station_name) %>%
  summarise(number_of_rides = n()) %>%
  filter(end_station_name != "NA") %>%
  arrange(desc(number_of_rides))

# total activity
station_departures <- yearly_tripdata_v2 %>%
  group_by(start_station_name) %>%
  summarise(departures = n()) %>%
  filter(start_station_name != "NA") %>%
  rename(station_name = start_station_name) %>%
  arrange(desc(departures))

station_arrivals <- yearly_tripdata_v2 %>%
  group_by(end_station_name) %>%
  summarise(arrivals = n()) %>%
  filter(end_station_name != "NA") %>%
  rename(station_name = end_station_name) %>%
  arrange(desc(arrivals))

station_activity <- merge(station_departures, station_arrivals, by = "station_name")
station_activity$total_rides <- station_activity$departures + station_activity$arrivals
station_activity <- arrange(station_activity, desc(total_rides))

## plotting
### top 20 stations by departures
yearly_tripdata_v2 %>%
  group_by(start_station_name) %>%
  summarise(number_of_rides = n()) %>%
  filter(start_station_name != "NA") %>%
  arrange(desc(number_of_rides)) %>%
  head(20) %>%
  ggplot(aes(x = reorder(start_station_name, number_of_rides), y = number_of_rides)) +
  geom_col() +
  coord_flip() +
  xlab("Station") + 
  ylab("Departures")

### top 20 stations by arrivals
yearly_tripdata_v2 %>%
  group_by(end_station_name) %>%
  summarise(number_of_rides = n()) %>%
  filter(end_station_name != "NA") %>%
  arrange(desc(number_of_rides)) %>%
  head(20) %>%
  ggplot(aes(x = reorder(end_station_name, number_of_rides), y = number_of_rides)) +
  geom_col() +
  coord_flip() +
  xlab("Station") + 
  ylab("Arrivals")

### top 10 stations by activity
station_activity_longer <- gather(station_activity, "depart_arrive", "rides", 2:3)
station_activity_longer %>%
  arrange(desc(total_rides)) %>%
  head(20) %>%
  ggplot(aes(x = reorder(station_name, total_rides), y = rides, fill = depart_arrive)) + 
  geom_col() + 
  coord_flip() +
  xlab("Station") +
  ylab("Rides") +
  labs(fill = " ")

