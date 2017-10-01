## Week 3 Quiz

## Question 1
file_data <- read.csv("ss06hid.csv")
agricultureLogical <- file_data$ACR == 3 & file_data$AGS == 6
which(agricultureLogical)
# 125  238  262

## Question 2
library(jpeg)
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg","jeff.jpg",method="curl")
pic <- readJPEG("jeff.jpg",native=TRUE)
quantile(pic,probs=seq(0,1,0.1))
#        0%       10%       20%       30%       40%       50% 
# -16776430 -15787693 -15518834 -15259150 -14927764 -14191406 
#       60%       70%       80%       90%      100% 
# -12363904 -11297076 -10575416  -5057565   -594524 


## Question 3
gdp_data <- read.csv("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv", skip=5L, nrows=190L,header=F)
education_data <- read.csv("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv")
matched_data <- merge(gdp_data, education_data, by.x="V1", by.y="CountryCode")
nrow(matched_data)
# 189
matched_data_ordered <- matched_data[order(matched_data$V2,decreasing=T),]
matched_data_ordered[13,"V4"]
# St. Kitts and Nevis


## Question 4
tapply(matched_data$V2,matched_data$Income.Group,mean)
#                      High income: nonOECD    High income: OECD 
#                   NA             91.91304             32.96667 
# Low income  Lower middle income  Upper middle income 
#  133.72973            107.70370             92.13333 


## Question 5
matched_data$gdp_rank_quantile <- cut(matched_data$V2, breaks=quantile(matched_data$V2, probs=seq(0,1,0.2)))
table(matched_data$gdp_rank_quantile, matched_data$Income.Group)
#                 High income: nonOECD High income: OECD Low income
#  (1,38.6]     0                    4                17          0
#  (38.6,76.2]  0                    5                10          1
#  (76.2,114]   0                    8                 1          9
#  (114,152]    0                    4                 1         16
#  (152,190]    0                    2                 0         11
#
#             Lower middle income Upper middle income
# (1,38.6]                      5                  11
# (38.6,76.2]                  13                   9
# (76.2,114]                   11                   8
# (114,152]                     9                   8
# (152,190]                    16                   9