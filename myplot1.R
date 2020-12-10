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

### Plot 1
hist(PC$Global_active_power, col = "red",
     main = "Global Active Power", xlab = "Global Active Power (kilowatts)")
dev.copy(png, filename="plot1.png")
dev.off()
