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

#Q3
library(ggplot2)
Type <- SCC %>% mutate(Data.Category=as.character(Data.Category)) %>%
        filter(Data.Category %in% c("Point","Nonpoint","Onroad","Nonroad")) %>%
        select(SCC, Data.Category) %>% mutate(SCC=as.character(SCC))
str(Type)
Joined <- left_join(NEI, Type, by = "SCC")
str(Joined)
Baltimore_type <- Joined %>% filter(fips=="24510") %>% group_by(Data.Category, year) %>% summarise(sum=sum(Emissions)) 
Baltimore_type <- Baltimore_type[1:16,]
Baltimore_type
png("plot3.png", width=480, height=480)
qplot(year, sum, data=Baltimore_type, col=Data.Category, main="Baltimore Annual Emissions") + geom_smooth(method="lm", se=FALSE) + ylab("Baltimore Annual Emissions (tons)")
dev.off()



