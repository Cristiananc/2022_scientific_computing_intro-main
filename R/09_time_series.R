library(dplyr)
library(ggplot2)
library(lubridate)
library(zoo)

#Reading the data
covid <- read.csv("data/raw/covid19-dd7bc8e57412439098d9b25129ae6f35.csv")

#Checking the class
class(covid$date)

head(covid)

#Changing the date format
covid$date <- as_date(covid$date)

#Checking the class
class(covid$date)

#Making numeric operations with the date
range(covid$date)
summary(covid$date)

#Plotting the time-series
ggplot(covid) +
  geom_line(aes(x = date, y = new_confirmed)) +
  theme_minimal()

#Since we have negative cases we will substitute these values
#per zero
covid$new_confirmed[covid$new_confirmed < 0] <- 0

ggplot(covid) +
  geom_line(aes(x = date, y = new_confirmed)) +
  theme_minimal() +
  scale_x_date(breaks = "4 months", date_labels = "%y %m") +
  labs(x = "Date", y = "New cases")

#Rolling mean
covid$roll_mean <- zoo::rollmean(covid$new_confirmed, 14, fill = NA)
head(covid)

ggplot(covid) +
  geom_line(aes(x = date, y = new_confirmed)) +
  theme_minimal() +
  scale_x_date(breaks = "4 months", date_labels = "%y %m") +
  labs(x = "Date", y = "New cases") +
  geom_line(aes(x = date, y = roll_mean), color = "blue", size = 1.2)
