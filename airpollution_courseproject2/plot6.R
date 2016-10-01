# Plot5 answering question: Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?

#1. load dataset.
sccpm25 <- readRDS(file ="../airpollution_courseproject2/summarySCC_PM25.rds")
scc <- readRDS(file ="../airpollution_courseproject2/Source_Classification_Code.rds")
#2. Merge the two datase
full_scc <- merge(sccpm25,scc,by = "SCC")
#3. sub data set 
motor_pm25 <- full_scc %>% filter(fips=="24510" | fips=="06037") %>% filter(grepl("([M|m]otor)",Short.Name) & grepl("([V|v]ehicle)",Short.Name)) 

#4.sum PM2.5 by year and type.
sum_motor_pm25 <- motor_pm25 %>% group_by(year,fips) %>% summarise(Emissions=sum(Emissions))
#5. Add city label  %>% mutate(fips.label=fips[])
sum_motor_pm25$city_label <- ifelse(sum_motor_pm25$fips=="24510", "Baltimore","Los Angeles")
#6. Plot using ggplot2
png(filename="../airpollution_courseproject2/plot6.png")
ggplot(sum_motor_pm25, aes(x=year, y=Emissions, color=city_label)) + geom_point() + geom_line()+labs(title="Motor Vehicle of Baltimore City and Los Angeles")
dev.off()