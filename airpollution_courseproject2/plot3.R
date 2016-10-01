## Plot 3,anwsering question:  Of the four types of sources indicated by the 𝚝𝚢𝚙𝚎 (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? Which have seen increases in emissions from 1999–2008? Use the ggplot2 plotting system to make a plot answer this question.

#1. load dataset.
sccpm25 <- readRDS(file ="../airpollution_courseproject2/summarySCC_PM25.rds")
scc <- readRDS(file ="../airpollution_courseproject2/Source_Classification_Code.rds")
#2. Merge the two datase
maryland_pm25 <- sccpm25 %>% filter(fips=="24510")

#3.sum PM2.5 by year and type.
sccbyyeartype <- maryland_pm25 %>% group_by(year,type) %>% summarise(Emissions=sum(Emissions))
#4. Plot using ggplot2
png(filename="../airpollution_courseproject2/plot3.png")
ggplot(sccbyyeartype, aes(x=year, y=Emissions, color=type)) + geom_point() + geom_line()+labs(title="Sources of decreased emmistions")
dev.off()
