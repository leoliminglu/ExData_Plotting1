### Getting and reading the data
if(!dir.exists("./Data")) {
    dir.create("./Data")
}
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
              destfile = "./Data/epc.zip", method = "curl")
unzip("./Data/epc.zip", exdir = "./Data")
library(data.table)
library(lubridate)
PCRaw <- read.table("./Data/household_power_consumption.txt", sep = ";")
names(PCRaw) <- PCRaw[1,]
PC1 <- PCRaw[-1,]
# change the classes of the variables
classes <- c(rep("character",2),rep("numeric",7))
for(i in 1:ncol(PC1)) {
    class(PC1[,i]) <- classes[i]
}
# subset the desired dates
PC <- PC1[PC1$Date=="1/2/2007"|PC1$Date=="2/2/2007",]
# change the class of time to Time and clear some redundancies
PC$Time <- paste(PC$Date,PC$Time)
PC$Time <- strptime(PC$Time, format="%d/%m/%Y %H:%M:%S")
PCnew <- PC[,-"Date"]
head(PCnew)

### Plot 4
par(mfrow = c(2,2))
with(PCnew, plot(Time,Global_active_power, type = "l", ylab="Global Active Power"))
with(PCnew, plot(Time,Voltage, type = "l", ylab="Voltage"))

with(PCnew, plot(Time, Sub_metering_1, type = "n", ylab = "Energy sub metering"))
with(PCnew, points(Time, Sub_metering_1, col = "black", type = "l",lwd = 1.5))
with(PCnew, points(Time, Sub_metering_2, col = "red", type = "l",lwd = 1.5))
with(PCnew, points(Time, Sub_metering_3, col = "blue", type = "l",lwd = 1.5))
legend("topright", lty = 1,lwd = 1.5, col = c("black","red","blue"),
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
with(PCnew, plot(Time,Global_reactive_power, type = "l", ylab="Global Reactive Power"))
dev.copy(png, filename="plot4.png")
dev.off()
