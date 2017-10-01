## Week 2 Quiz

## Question 1
# Example code found here: 
# https://medium.com/towards-data-science/accessing-data-from-github-api-using-r-3633fb62cb08

#install.packages("jsonlite")
library(jsonlite)
#install.packages("httpuv")
library(httpuv)
#install.packages("httr")
library(httr)

# Can be github, linkedin etc depending on application
oauth_endpoints("github")

# Change based on what you 
myapp <- oauth_app(appname = "Coursera_John_Hopkins",
                   key = "MY_KEY",
                   secret = "MY_SECRET")

# Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

# Use API
gtoken <- config(token = github_token)
req <- GET("https://api.github.com/users/jtleek/repos", gtoken)

# Take action on http error
stop_for_status(req)

# Extract content from a request
json1 = content(req)

# Convert to a data.frame
gitDF = jsonlite::fromJSON(jsonlite::toJSON(json1))

# Subset data.frame
gitDF[gitDF$full_name == "jtleek/datasharing", "created_at"] 


## Question 4
con = url("http://biostat.jhsph.edu/~jleek/contact.html")
pageHtml <- readLines(con)
close(con)
lapply(pageHtml[c(10,20,30,100)],nchar)


## Question 5
file_data <- read.fwf("https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for",widths=c(-1L,9L,-5L,4L,4L,-5L,4L,4L,-5L,4L,4L,-5L,4L,4L),skip=4L,col.names=c("Week","Nino1+2.SST","Nino1+2.SSTA","Nino3.SST","Nino3.SSTA","Nino34.SST","Nino34.SSTA","Nino4.SST","Nino4.SSTA"))
sum(file_data$Nino3.SST)