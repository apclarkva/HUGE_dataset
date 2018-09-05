# Need library for reading excel files
# V11 is HUGE
# 
library(dplyr)
library(plyr)

closeAllConnections()
rm(list=ls())


allProjects <- read.table("SraRunTable.txt", fill=TRUE)
allProjects <- allProjects[2:nrow(allProjects),]

hugeProjects <- allProjects[grep("HUGE", allProjects$V11),]

hugeSRR <- as.character(hugeProjects$V21)

write.table(hugeSRR, file="srr.txt", col.names = FALSE, row.names = FALSE, sep=" ")

header.true <- function(df) {
  names(df) <- as.character(unlist(df[1,]))
  df[-1,]
}

#v23 is HUGE, with date, so is 
#V11 looks like the same as v23
#v21 is SRR number
hugeDF <- data.frame("sample" = hugeProjects$V11, "SRR" = hugeProjects$V21)

#candidate B values
candidateB <- hugeDF[grep("-B-", hugeDF$sample),]
candidateB$sample <- sub("HUGE-B-", "2013-", candidateB$sample)
candidateB$sample <- as.Date(sub(".ST", "", candidateB$sample))

#altered DF
candidateA <- hugeDF[-grep("-B-", hugeDF$sample),]
candidateA$sample <- sub("HUGE", "2013", candidateA$sample)
candidateA$sample <- as.Date(sub(".ST", "", candidateA$sample))

#read in measurements from .tab file
sampleTableA <- data.frame("SRR" = character(0),
                          "Date" = character(0),
                          "Candidate" = character(0), 
                          "Scaffolds" = character(0),
                          "Split.Site.1" = character(0),
                          "Split.Site.2" = character(0),
                          "Supporting.Split.Reads" = character(0),
                          "Supporting.Read.Pairs.first.in.pair." = character(0))
sampleTableB <- sampleTableA


add_to_table <- function(SRR, date, candidate, sampleTable) {
  sampleRead <- read.table(paste("mobile-elements/", SRR,".mobile.tab", sep=""), header = TRUE, sep="\t")
  sampleReadDimensions <- dim(sampleRead) #use first dimensions

  if(sampleReadDimensions[1] == 0) {

    sampleRead <- data.frame("Scaffolds" = c(NA),
                             "Split.Site.1" = c(NA),
                             "Split.Site.2" = c(NA),
                             "Supporting.Split.Reads" = c(NA),
                             "Supporting.Read.Pairs.first.in.pair." = c(NA))
    sampleReadDimensions <- c(1,1)
  }

  allSampleList <- data.frame("SRR" = rep(SRR, sampleReadDimensions[1]),
                              "Date" = rep(date, sampleReadDimensions[1]),
                              "Candidate" = rep(candidate, sampleReadDimensions[1])
  )
    

  
  #merge allSampleList with sampleRead
  allSampleList <- cbind(allSampleList, sampleRead)
  newSampleTable <- rbind(sampleTable,allSampleList)
  return(newSampleTable)
}



for(row in 1:nrow(candidateA)) {
  sampleTableA <- add_to_table(as.character(candidateA$SRR[row]), 
                              as.character(candidateA$sample[row]), 
                              "A", 
                              sampleTableA)  
}

for(row in 1:nrow(candidateB)) {
  sampleTableB <- add_to_table(as.character(candidateB$SRR[row]), 
                              as.character(candidateB$sample[row]), 
                              "B", 
                              sampleTableB)  
}

#sampleTable sorted by date
sampleTableA <- sampleTableA[order(as.Date(sampleTableA$Date)),]
sampleTableB <- sampleTableB[order(as.Date(sampleTableB$Date)),]

tableA <- sampleTableA[!is.na(sampleTableA$Scaffolds),]
tableB <- sampleTableB[!is.na(sampleTableB$Scaffolds),]


samplesACount <- table(tableA$Date)
samplesBCount <- table(tableB$Date)

samplesACountOrder <- samplesACount[order(as.Date(names(samplesACount)))]
samplesBCountOrder <- samplesBCount[order(as.Date(names(samplesBCount)))]

par(mfrow=c(1,2))
barplot(samplesACountOrder, main="Candidate A",
        xlab = "Date", ylab = "Count Detected Potential MGEs")
barplot(samplesBCountOrder, main="Candidate B",
        xlab = "Date", ylab = "Count Detected Potential MGEs")




