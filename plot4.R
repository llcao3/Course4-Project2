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

#Q4
library(ggplot2)
coalcomb <- SCC %>% mutate(SCC=as.character(SCC), Short.Name=as.character(Short.Name)) %>%
        select(SCC, Short.Name) %>%
        filter(grepl("Coal",Short.Name)&grepl("Comb",Short.Name)) %>% distinct()
innerjoin <- inner_join(NEI,coalcomb, by="SCC")
str(innerjoin)
coalcomb_emissions <- innerjoin %>% group_by(year) %>% summarise(sum=sum(Emissions))
png("plot4.png", width=480, height=480)
qplot(year, sum, data=coalcomb_emissions, main="Coal Combustion Emissions") + 
        geom_smooth(method="lm", se=FALSE) + 
        ylab("Coal Combustion Emissions (tons)")
dev.off()

