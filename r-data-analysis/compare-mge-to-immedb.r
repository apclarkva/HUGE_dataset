# Need library for reading excel files
# V11 is HUGE
# 
library(dplyr)
library(plyr)

closeAllConnections()
rm(list=ls())


sampleTableA <- read.csv("CandidateA.csv", header = TRUE)
sampleTableB <- read.csv("CandidateB.csv", header = TRUE)
immedb <- read.csv("ImmeDBBlast.csv", header=TRUE)

tableA <- sampleTableA[!is.na(sampleTableA$Scaffolds),]
tableB <- sampleTableB[!is.na(sampleTableB$Scaffolds),]

immedbIntegrases <- sub("\\..*", "",immedb$MGE.coordinate)
tableB$integrases <- sub(".*ref\\|", "",tableB$Scaffolds)
tableB$integrases <- sub("\\..*", "", tableB$integrases)