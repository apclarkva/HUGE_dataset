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
  
  if(sampleReadDimensions[1] <= 1) {
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
samplesACountOrder <- replace(samplesACountOrder, samplesACountOrder == 0, 1)
plot(as.Date(names(samplesACountOrder)), unname(samplesACountOrder), main="Candidate A",
        xlab = "Date", ylab = "Count Detected Potential MGEs", ylim=c(0, 40), yaxp = c(0, 40, 4))
lines(as.Date(names(samplesACountOrder)), unname(samplesACountOrder))
points(as.Date(names(samplesACountOrder[samplesACountOrder==1])), samplesACountOrder[samplesACountOrder==1], bg="black", pch=21)
axis(side=2, at=seq(0,40,10), labels=seq(0,40,10))


samplesBCountOrder <- replace(samplesBCountOrder, samplesBCountOrder == 0, 1)
plot(as.Date(names(samplesBCountOrder)), unname(samplesBCountOrder), main="Candidate B",
     xlab = "Date", ylab = "Count Detected Potential MGEs", ylim=c(0, 40), yaxp = c(0, 40, 4))
lines(as.Date(names(samplesBCountOrder)), samplesBCountOrder)
points(as.Date(names(samplesBCountOrder[samplesBCountOrder==1])), samplesBCountOrder[samplesBCountOrder==1], bg="black", pch=21)
axis(side=2, at=seq(0,40,10), labels=seq(0,40,10))


sampleBOverlap <- samplesBCountOrder[13:15]
tableBOverlap <- tableB[is.element(as.Date(tableB$Date), as.Date(names(sampleBOverlap))),]
dupScaffolds <- tableBOverlap$Scaffolds[duplicated(tableBOverlap$Scaffolds)]
tableBOverlap <- tableBOverlap[is.element(tableBOverlap$Scaffolds, dupScaffolds),]

dupSplit <- tableBOverlap$Split.Site.1[duplicated(tableBOverlap$Split.Site.1)]
tableBOverlap <- tableBOverlap[is.element(tableBOverlap$Split.Site.1, dupSplit),]

findOverlapB <- data.frame(date = tableBOverlap$Date, scaffolds = tableBOverlap$Scaffolds, split = tableBOverlap$Split.Site.1)



sampleAOverlap <- samplesACountOrder[1:13]
tableAOverlap <- tableA[is.element(as.Date(tableA$Date), as.Date(names(sampleAOverlap))),]
dupScaffolds <- tableAOverlap$Scaffolds[duplicated(tableAOverlap$Scaffolds)]
tableAOverlap <- tableAOverlap[is.element(tableAOverlap$Scaffolds, dupScaffolds),]

dupSplit <- tableAOverlap$Split.Site.1[duplicated(tableAOverlap$Split.Site.1)]
tableAOverlap <- tableAOverlap[is.element(tableAOverlap$Split.Site.1, dupSplit),]

findOverlapA <- data.frame(date = tableAOverlap$Date, scaffolds = tableAOverlap$Scaffolds, split = tableAOverlap$Split.Site.1)

