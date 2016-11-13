# Plot5 answering question: How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?
library(ggplot2)
library(dplyr)
#1. load dataset.
sccpm25 <- readRDS(file ="../airpollution_courseproject2/summarySCC_PM25.rds")
scc <- readRDS(file ="../airpollution_courseproject2/Source_Classification_Code.rds")
#2. Merge the two datase
full_scc <- merge(sccpm25,scc,by = "SCC")
#3. sub data set 
motor_pm25 <- full_scc %>% filter(fips=="24510") %>% filter(grepl("([V|v]ehicle)",EI.Sector)) 
#4.sum PM2.5 by year and type.
sum_motor_pm25 <- motor_pm25 %>% group_by(year,type) %>% summarise(Emissions=sum(Emissions))
#5. Plot using ggplot2
png(filename="../airpollution_courseproject2/plot5.png")
ggplot(sum_motor_pm25, aes(x=year, y=Emissions, color=type)) + geom_point() + geom_line()+labs(title="Motor Vehicle of Baltimore City")
dev.off()
