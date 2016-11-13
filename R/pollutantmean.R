pollutantmean <- function(directory,pollutant,id=1:332){
   files <- list.files(directory,full.names=T)
   dataset <- do.call(rbind,lapply(files,read.csv,header=TRUE))
   mean(dataset[which(dataset$ID %in% id),pollutant],na.rm=T)
}