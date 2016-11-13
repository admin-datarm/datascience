complete <- function(directory,id=1:332){
	files <- list.files(directory,full.names=T)
	nrows <- length(id)
	freqs <- data.frame(id=integer(nrows),nobs=integer(nrows))
	index <- 1
	for(i in id){
		oneDataset <- read.csv(files[i],header=T)
		nobs <- length(oneDataset[!is.na(oneDataset$sulfate) & !is.na(oneDataset$nitrate),"ID"])
		freqs$id[index]=i
		freqs$nobs[index]=nobs
		index = index +1
	}
  	freqs
}

