## Plot 1, Anwsering questions : have total emissions from PM2.5 decreased in the United States from 1999 to 2008? Using the base plotting system, make a plot showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.

#1. load dataset.
sccpm25 <- readRDS(file ="../airpollution_courseproject2/summarySCC_PM25.rds")
#2. summarize PM2.5 each year.
sccbyyear <- sccpm25 %>% group_by(year) %>% summarise(sum(Emissions))
sccbyyear$year <- as.character(sccbyyear$year)
#3. plot
png(filename="../airpollution_courseproject2/plot1.png")
plot(sccbyyear$year,sccbyyear$`sum(Emissions)`,xlab = "Year",ylab = "Emissions",type = "b",main="Total emissions of PM2.5")
dev.off()