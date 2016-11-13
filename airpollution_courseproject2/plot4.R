# Plot4 answering question: Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?
library(ggplot2)
library(dplyr)
#1. load dataset.
sccpm25 <- readRDS(file ="../airpollution_courseproject2/summarySCC_PM25.rds")
scc <- readRDS(file ="../airpollution_courseproject2/Source_Classification_Code.rds")
#2. Merge the two datase
full_scc <- merge(sccpm25,scc,by = "SCC")
#3. sub data set of Coal
coal_pm25 <- full_scc %>% filter(grepl("([c|C]oal)",EI.Sector))
#5.sum PM2.5 by year
sum_coal_pm25 <- coal_pm25 %>% group_by(year) %>% summarise(Emissions=sum(Emissions))
#6. Plot using ggplot2
png(filename="../airpollution_courseproject2/plot4.png")
ggplot(sum_coal_pm25, aes(x=year, y=Emissions)) + geom_point() + geom_line()+labs(title="Coal combustion-related sources")
dev.off()
