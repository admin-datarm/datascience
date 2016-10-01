## Plot 2, Anwsering questions : have total emissions from PM2.5 decreased in the Baltimore City, Maryland  from 1999 to 2008? Use the base plotting system to make a plot answering this question.

#1. load dataset.
sccpm25 <- readRDS(file ="../airpollution_courseproject2/summarySCC_PM25.rds")

#2. subdataset with Baltimore City,Maryland
maryland_pm25 <- sccpm25 %>% filter(fips=="24510")

#3.PM2.5 each year.
sccbyyear <- maryland_pm25 %>% group_by(year) %>% summarise(sum(Emissions))
sccbyyear$year <- as.character(sccbyyear$year)
#4. plot
png(filename="../airpollution_courseproject2/plot2.png")
plot(sccbyyear$year,sccbyyear$`sum(Emissions)`,xlab = "Year",ylab = "Emissions",type = "b",main = "Total emissions of PM2.5 in Maryland")
dev.off()