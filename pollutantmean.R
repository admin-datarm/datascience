pollutantmean <- function(directory,pollutant,id=1:332){
  pollutantDataSet <- read.csv(directory,header = TRUE)
  subsetById <- pollutantDataSet[pollutantDataSet$ID %in% id,]
  mean(subsetById[,pollutant],na.rm = TRUE)
}