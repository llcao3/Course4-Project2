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

#Q5
library(ggplot2)
motorveh <- SCC %>% mutate(SCC=as.character(SCC), Short.Name=as.character(Short.Name)) %>%
        select(SCC, Short.Name) %>%
        filter(grepl("Veh",Short.Name)) %>% distinct()
Baltimore <- NEI %>% filter(fips=="24510")
innerjoin <- inner_join(Baltimore,motorveh, by="SCC")
Baltimore_motorveh <- innerjoin %>% group_by(year) %>% summarise(sum=sum(Emissions))
png("plot5.png", width=480, height=480)
qplot(year, sum, data=Baltimore_motorveh, main="Baltimore Motor Vehicle Emissions") +
        geom_smooth(method="lm", se=FALSE) +
        ylab("Baltimore Motor Vehcile Emissions (tons)") +
        theme(plot.title=element_text(hjust=0.5))
dev.off()



