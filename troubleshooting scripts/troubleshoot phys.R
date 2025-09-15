library(tidyverse)
library(gridExtra) # combine plots
library(stringr)
library(readr)
library(lubridate)
library(plotly)
library(viridis)
library(kableExtra)
library(tidylog)



#Sensors
#Water Temp in F =25  (2008)
#DO= 61  (2013)
#Conductivity = 100  (2013)
#pH =62   (2013)
#Turbidity =221  (2013)

# Read files (came from cdec4gov)
LIS_WaterTemperature <- read_csv("drift data/STA/LIS_25.csv")
LIS_DO <- read_csv("drift data/STA/LIS_61.csv")
LIS_pH <- read_csv("drift data/STA/LIS_62.csv")
LIS_Turb <- read_csv("drift data/STA/LIS_221.csv")
LIS_EC <- read_csv("drift data/STA/LIS_100.csv")
# LIS_EC$`DATE TIME` <- mdy_hm(LIS_EC$`DATE TIME`)

LIS_WaterTemperature_ed <- LIS_WaterTemperature %>%
  select(3,5) %>%
  filter(parameter_value<99998) %>%
  mutate(Temp_C = round((parameter_value-32)*5/9,1)) %>%
  rename(Temp_F = parameter_value)
LIS_WaterTemperature_ed$Time <- hms::as_hms(LIS_WaterTemperature_ed$datetime)
LIS_WaterTemperature_ed$Date <- as_date(LIS_WaterTemperature_ed$datetime)
LIS_WaterTemperature_ed$Hour <- as.numeric(format(strptime(LIS_WaterTemperature_ed$Time, "%H:%M:%S"), "%H"))
LIS_WaterTemperature_ed <- LIS_WaterTemperature_ed %>% 
  filter(year(Date) >2012)
LIS_DO_ed <- LIS_DO %>%
  select(3,5) %>%
  rename(DO = parameter_value)
LIS_pH_ed <- LIS_pH %>%
  select(3,5) %>%
  rename(pH = parameter_value)
LIS_Turb_ed <- LIS_Turb %>%
  select(3,5) %>%
  rename(Turbidity = parameter_value)
LIS_EC_ed <- LIS_EC%>%
  select(3,5) %>%
  rename(Conductivity = parameter_value)

# Merge variables together
a <- merge(LIS_DO_ed, LIS_Turb_ed, by = "datetime")
b <- merge(a, LIS_EC_ed, by = "datetime")
c <- merge(b, LIS_pH_ed, by = "datetime")
LIS_WQ <- full_join(LIS_WaterTemperature_ed, c, by = "datetime") %>% 
  filter(!is.na(datetime))

# str(LIS_WQ)
LIS_WQ$Time <- hms::as_hms(LIS_WQ$datetime)
LIS_WQ$Date <- as_date(LIS_WQ$datetime)
LIS_WQ$Hour <- as.numeric(format(strptime(LIS_WQ$Time, "%H:%M:%S"), "%H"))

LIS_WQ_f <- LIS_WQ %>%
  rename(WaterTemperature = Temp_C) %>%
  dplyr::filter(Hour>06 & Hour<15) %>%
  dplyr::filter(WaterTemperature>0 & WaterTemperature<40) %>%
  dplyr::filter(Conductivity>0)%>%
  filter(DO>0)%>%
  filter(pH>0 & pH<14)%>%
  filter(Turbidity >0) %>%
  mutate(StationCode="LIS_RT") %>%
  select(1,3:7,9,11)
