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

#Q6
library(ggplot2)
motorveh <- SCC %>% mutate(SCC=as.character(SCC), Short.Name=as.character(Short.Name)) %>%
        select(SCC, Short.Name) %>%
        filter(grepl("Veh",Short.Name)) %>% distinct()
filtered <- NEI %>% filter(fips=="24510"|fips=="06037")
innerjoin<- inner_join(filtered,motorveh, by="SCC")
emissions_motorveh <- innerjoin %>% group_by(fips, year) %>% summarise(sum=sum(Emissions))
fips <- emissions_motorveh$fips
png("plot6.png", width=480, height=480)
g <- ggplot(emissions_motorveh, aes(year, sum, col=fips)) + geom_point()
g + geom_smooth(method="lm", se=FALSE) + ggtitle("Motor Vehicle Emssions") + 
        ylab("Motor Vehicle Emssions (tons)") +
        theme(plot.title=element_text(hjust=0.5)) +
        scale_colour_discrete(name="City", labels=c("LA", "Baltimore"))
dev.off()


