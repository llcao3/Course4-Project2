setwd("/Users/lulu/R_Coursera/Course4-Project2")
library(data.table)
library(dplyr)

#download the zip file and unzip it
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
if(!file.exists("summarySCC_PM25.rds")) {
        download.file(fileUrl, destfile = "c4p2.zip", method = "curl")
        dateDownloaded <- date()
        unzip("c4p2.zip")
}

#loading the dataset into r using "fread" (it is supposed to be much faster than
#"read.table" and you can limit the lines read into r)
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

str(NEI)
str(SCC)

#Q1

Total <- NEI %>% group_by(year) %>% summarise(sum=sum(Emissions))
str(Total)
png("plot1.png", width=480, height=480)
with(Total, plot(year, sum, main="Total Annual Emissions", pch=20, ylab="Total Annual Emissions (tons)"))
model <- lm(sum~year, Total)
abline(model, lwd=2)
dev.off()



