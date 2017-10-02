## Week 4 Quiz

## Question 1
dat <- read.csv("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv")
namesplits <- strsplit(names(dat),"wgtp")
namesplits[123]
# [1] ""   "15"

## Question 2
dat <- read.csv("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv",skip=5,nrows=190,header=F)
dat$V5 <- as.numeric(sub(",","",dat$V5))
mean(dat$V5)
# 377652.4

## Question 4
edat <- read.csv("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv")
mdat <- merge(dat, edat, by.x="V1", by.y="CountryCode")
fydat <- mdat[grepl("Fiscal year end: June", mdat$Special.Notes),]
nrow(fydat)
# 13

## Question 5
library(quantmod)
amzn = getSymbols("AMZN",auto.assign=FALSE)
sampleTimes = index(amzn)
sum(year(sampleTimes) == 2012)
# 250
sum(year(sampleTimes) == 2012 & wday(sampleTimes, label=T) == "Mon")
# 47