
# The datasets used “Individual household electric power consumption Data Set”
# is the Measurements of electric power consumption in one household with
# a one-minute sampling rate over a period of almost 4 years.

require("downloader")
require("data.table")

# Verification of the directory to datas
if(!file.exist("data")) dir.create("./data")

## Download the data package
fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download(fileURL, "./data/", method = "wb")

unzip("./data/epcpack.zip")
# file.size <- file.info("household_power_consumption.txt")$size/1048576

## Load the dataset
loadData <- function(){
        #read.table("./data/household_power_consumption.txt", sep = ";", header = TRUE) 
        fread("./data/household_power_consumption.txt", sep = ";", header = TRUE, na.strings = "?")
}

## Calculate a rough estimate of how much memory the dataset will require in memory
# system.time(loadData())
# object.size(loadData())

epcData <-loadData()

## Subsetting using only data from the dates 2007-02-01 and 2007-02-02
# dim()2007-02-01 and 2007-02-02
epcData.sub <- as.data.frame(epcData[(Date == "1/2/2007"|Date == "2/2/2007"),])

epcData.sub.date <- as.Date(epcData.sub$Date, format = "%d/%m/%Y")
# epcData.sub.time <- as.ITime(epcData.sub$Time, format = "%H:%M:%S")

tidyData <- data.frame(epcData.sub.date, epcData.sub[, c(2:9)])
names(tidyData) <- c("Date", "Time", "Global.Active.Power", 
                     "Global.Reactive.Power", "Voltage", 
                     "Global.Intensity", "Sub.Metering.1", 
                     "Sub.Metering.2", "Sub.Metering.3")

## Add class to columns
class(tidyData$Global.Active.Power) <- "float"
class(tidyData$Global.Reactive.Power) <- "float"
class(tidyData$Voltage) <- "float"
class(tidyData$Global.Intensity) <- "float"
class(tidyData$Sub.Metering.1) <- "integer"
class(tidyData$Sub.Metering.2) <- "integer"
class(tidyData$Sub.Metering.3) <- "integer"

##
## PLot 4 
## the names of the days shown in the language installed of RStudio
##
png(file = "./data/plot4.png")

## Representation of the date and time an object of class "POSIXlt
date.time <- strptime(paste(tidyData$Date, tidyData$Time), "%Y-%m-%d %H:%M:%S")

par(mfrow = c(2,2))

## Subplot 1,1
plot(date.time, tidyData$Global.Active.Power, type = "l", 
     xlab = "", ylab = "Global Active Power")

## Subplot 1,2
plot(date.time, tidyData$Voltage, type = "l", 
     xlab = "datetime", ylab = "Voltage")

## Subplot 2,1
plot(date.time, tidyData$Sub.Metering.1, type = "l", 
     xlab = "", ylab = "Energy sub metering")

lines(date.time, tidyData$Sub.Metering.2, type="l",col="red")
lines(date.time, tidyData$Sub.Metering.3, type="l",col="blue")

legend("topright", col = c("black","red","blue"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       lwd = 2, box.lwd = 0, bg = "transparent")

## Subplot 2,2
plot(date.time, tidyData$Global.Reactive.Power, type = "l", 
     xlab = "datetime", ylab = "Global_reactive_power")

dev.off()