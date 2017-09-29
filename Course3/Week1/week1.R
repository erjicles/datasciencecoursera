## Week 1 Assignment
library(xlsx)

## Question 1
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv", "ss06hid.csv", "curl")
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf", "PUMSDataDict06.pdf", "curl")
housing_data <- read.csv("ss06hid.csv")
housing_data_idaho <- housing_data[housing_data$ST == 16,]
housing_data_idaho_1M <- housing_data_idaho[housing_data_idaho$VAL == 24,]
housing_data_idaho_1M <- housing_data_idaho_1M[!is.na(housing_data_idaho_1M$VAL),]
nrow(housing_data_idaho_1M)
# 53

## Question 3
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx", "gov_NGAP.xlsx", "curl")
dat <- read.xlsx("gov_NGAP.xlsx", sheetIndex=1, rowIndex=18:23, colIndex=7:15)
sum(dat$Zip*dat$Ext,na.rm=T)
# 36534720

## Question 4
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml", "bmore_restaurants.xml", "curl")
bmore_restaurants <- xmlTreeParse("bmore_restaurants.xml", useInternal=T)
rootNode <- xmlRoot(bmore_restaurants)
rs_with_zip <- xpathSApply(rootNode, "//zipcode[text()='21231']", xmlValue)
length(rs_with_zip)
# 127

## Question 5
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv", "ss06pid.csv", "curl")
DT <- fread("ss06pid.csv")
system.time(sapply(split(DT$pwgtp15,DT$SEX),mean))
#  user  system elapsed 
# 0.001   0.000   0.001
system.time(DT[,mean(pwgtp15),by=SEX])
#  user  system elapsed 
# 0.001   0.001   0.006 
system.time(tapply(DT$pwgtp15,DT$SEX,mean))
#         user       system      elapsed 
# 0.0020000000 0.0000000000 0.0009999999 
system.time(mean(DT$pwgtp15,by=DT$SEX))
#  user  system elapsed 
# 0       0       0 
system.time({rowMeans(DT)[DT$SEX==1]; rowMeans(DT)[DT$SEX==2]})
# Error in rowMeans(DT) : 'x' must be numeric
# Timing stopped at: 0.823 0.025 0.853
system.time({mean(DT[DT$SEX==1,]$pwgtp15); mean(DT[DT$SEX==2,]$pwgtp15)})
#  user  system elapsed 
# 0.022   0.000   0.021 