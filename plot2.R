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

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

str(NEI)
str(SCC)

#Q2
Baltimore <- NEI %>% filter(fips=="24510") %>% group_by(year) %>% summarise(sum=sum(Emissions))
str(Baltimore)
png("plot2.png", width=480, height=480)
with(Baltimore, plot(year, sum, main="Baltimore Total Annual Emissions", pch=20, ylab="Total Annual Emissions (tons)"))
model <- lm(sum~year, Baltimore)
abline(model, lwd=2)
dev.off()



