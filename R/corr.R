corr <- function(directory,threshold=0){
	files <- list.files(directory,full.names=T)
  	idFreqTable <- complete(directory)
  	overThresholdIds <- idFreqTable[idFreqTable$nobs>threshold,"id"]
  	if(length(overThresholdIds)==0){
  		return(numeric(0))
  	}
  	sapply(overThresholdIds,eachcorr)
}
eachcorr <- function(mid){
	dataset <- do.call(rbind,lapply(files[mid],read.csv,header=TRUE))
  	datasetOverThr <- dataset[!is.na(dataset$sulfate) & !is.na(dataset$nitrate),]
  	cor(c(datasetOverThr$sulfate),c(datasetOverThr$nitrate))
}
