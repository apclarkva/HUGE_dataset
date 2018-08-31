# Need library for reading excel files
# V11 is HUGE
# 
library(dplyr)
library(plyr)


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

#altered DF
candidateA <- hugeDF[-grep("-B-", hugeDF$sample),]








