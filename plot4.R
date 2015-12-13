# Exploratory Data Analysis - Project 1, Plot 4
# Due:Sunday, December 13, 2015
# Author: Ken R.

#------------------------------------------------------------------------------
# Part I - Set working directory, download and unzip project file, load required R Packages.

setwd("~/Documents/Online Courses/Exploratory Data Analysis/Project 1")

library("data.table", lib.loc="/Library/Frameworks/R.framework/Versions/3.1/Resources/library")

library("dplyr", lib.loc="/Library/Frameworks/R.framework/Versions/3.1/Resources/library")

library("lubridate", lib.loc="/Library/Frameworks/R.framework/Versions/3.1/Resources/library")

# Note: Data is now downloaded, so no need to repeat

# if(!file.exists("./data")){dir.create("./data")}
# fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip?accessType=DOWNLOAD"
# download.file(fileUrl,destfile="./Fhousehold_power_consumption.zip",method="curl")
# dateDownloaded <- date()
#
# unzip("Fhousehold_power_consumption.zip.zip", exdir = "./data")

#------------------------------------------------------------------------------
# Part II Build a New Data Frame from the text file:

# Create a data frame from text file rows that match the date criteria.
raw_data <- read.table(pipe('grep "^[1-2]/2/2007" "./data/household_power_consumption.txt"'), sep = ";", , stringsAsFactors = FALSE )

# Copy the original column names to the new data_frame:
cols <- read.table("./data/household_power_consumption.txt", sep = ";", header = TRUE, nrows = 1)
names(raw_data) <- names(cols)

# Combine the date and time columns to create a new variable/column in POSIXct format:
Date_time <- dmy_hms(paste(raw_data$Date, raw_data$Time))

# Add new column to data frame:
raw_data <- mutate(raw_data, Date_time)

# Rearrange the column order to improve readability
raw_data <- select(raw_data, Date, Time, Date_time, Global_active_power:Sub_metering_3)

#------------------------------------------------------------------------------
# Part III - Set up the Graphics Device and Draw the Plot:

# Plot size should be 480 x 480 pixels (5 inches x 5 inches). Note that "quartz" is specific to OS X default/screen graphics device.
quartz(width=5, height=5, bg="white")

png("plot4.png")

# Plot 4 - Combination of 4 Charts:
layout(matrix(1), widths = lcm(12.7), heights = lcm(12.7))
par(mfrow = c(2, 2))

# 4.1 Global Active Power (upper left)
plot(raw_data$Date_time, raw_data$Global_active_power, type="n", ylab= "Global Active Power (kilowatts)", xlab="")
lines(raw_data$Date_time, raw_data$Global_active_power)

# 4.2 Voltage (upper right)
plot(raw_data$Date_time, raw_data$Voltage, type="n", ylab= "Voltage", xlab="")
lines(raw_data$Date_time, raw_data$Voltage)
title(xlab="datetime")

# 4.3 Energy Sub Metering (lower left)
plot(raw_data$Date_time, raw_data$Sub_metering_1, col="black", type="l", ylab= "Energy sub metering", xlab="")
lines(raw_data$Date_time, raw_data$Sub_metering_2, col="red")
lines(raw_data$Date_time, raw_data$Sub_metering_3, col="blue")
legend("topright", cex=0.6, lty = 1, col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), bty = "n")

# 4.4 Global Reactive Power (lower right)
plot(raw_data$Date_time, raw_data$Global_reactive_power, type="n", ylab= "Global reactive power", xlab="")
lines(raw_data$Date_time, raw_data$Global_reactive_power)
title(xlab="datetime")

dev.off()

#------------------------------------------------------------------------------
# End of Code