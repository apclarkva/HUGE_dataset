# Need library for reading excel files
# V11 is HUGE

library(dplyr)
library(plyr)

closeAllConnections()
rm(list=ls())


sampleTableA <- read.csv("CandidateA.csv", header = TRUE)
sampleTableB <- read.csv("CandidateB.csv", header = TRUE)

tableA <- sampleTableA[!is.na(sampleTableA$Scaffolds),]
tableB <- sampleTableB[!is.na(sampleTableB$Scaffolds),]

sridCountA <- table(tableA$Scaffolds)
sridCountA <- sridCountA[order(sridCountA)]
sridCountA <- data.frame(rev(sridCountA))

sridCountB <- table(tableB$Scaffolds)
sridCountB <- sridCountB[order(sridCountB)]
sridCountB <- data.frame(rev(sridCountB))


