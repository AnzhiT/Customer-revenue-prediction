setwd("C:/Users/Anzhi Tian/Desktop/data")
train<-read.csv("train_flat.csv", header = T)
length(unique(train))

#delete all the non-sense variables
train$socialEngagementType <- NULL
train$browserVersion <- NULL
train$operatingSystemVersion <- NULL
train$mobileDeviceBranding <- NULL
train$mobileDeviceModel <- NULL
train$mobileInputSelector <- NULL
train$mobileDeviceInfo <- NULL
train$mobileDeviceMarketingName <- NULL
train$flashVersion <- NULL
train$language <- NULL
train$screenColors <- NULL
train$screenResolution <- NULL
train$latitude <- NULL
train$longitude <- NULL
train$networkLocation <- NULL
train$adwordsClickInfo.criteriaParameters <- NULL
train$adwordsClickInfo.adNetworkType <- NULL
train$adwordsClickInfo.gclId <- NULL
train$adwordsClickInfo.isVideoAd <- NULL
train$adwordsClickInfo.page <- NULL
train$adwordsClickInfo.slot <- NULL
train$keyword <- NULL
train$adContent <- NULL
train$campaignCode <- NULL
train$sessionId <- NULL
train$cityId <- NULL
train$browserSize <- NULL
train$visits<-NULL
train$referralPath<-NULL

#transfer date-quarter
library(data.table)
#Character Data to Date Format
train$Date <- as.Date(as.character(train$date), "%Y%m%d")
#Convert Date to qrt
train$qrt1 <- ifelse(quarter(train$Date)==1,1,0)
train$qrt2 <- ifelse(quarter(train$Date)==2,1,0)
train$qrt3 <- ifelse(quarter(train$Date)==3,1,0)
train$qrt4 <- ifelse(quarter(train$Date)==4,1,0)
train$date <-NULL

#channelgrouping: #Direct, Organic Search,Referral, Social, Paid Search, Affiliates, others
is.factor(train$channelGrouping)
contrasts(train$channelGrouping)
train$OrganicSearch[train$channelGrouping=="Organic Search"] <- 1
train$OrganicSearch[train$channelGrouping!="Organic Search"] <- 0
train$Social[train$channelGrouping=="Social"] <- 1
train$Social[train$channelGrouping!="Social"] <- 0
train$Direct[train$channelGrouping=="Direct"] <- 1
train$Direct[train$channelGrouping!="Direct"] <- 0
train$Referral[train$channelGrouping=="Referral"] <- 1
train$Referral[train$channelGrouping!="Referral"] <- 0
train$PaidSearch[train$channelGrouping=="Paid Search"] <- 1
train$PaidSearch[train$channelGrouping!="Paid Search"] <- 0
train$Affiliates <- ifelse(train$channelGrouping=="Affiliates",1,0)
train$OtherChannel[train$channelGrouping!="Direct" & train$channelGrouping!="Organic Search" & train$channelGrouping!="Referral" & train$channelGrouping!="Social" & train$channelGrouping!="Paid Search" & train$channelGrouping!="Affiliates"] <- 1
train$OtherChannel[train$channelGrouping=="Direct"|train$channelGrouping=="Organic Search"|train$channelGrouping=="Referral"|train$channelGrouping=="Social"|train$channelGrouping=="Paid Search"| train$channelGrouping=="Affiliates"] <- 0
train$channelGrouping <- NULL
table(train$channelGrouping)/sum(table(train$channelGrouping))

#browser: chrome, safari, firefox, IE, others
train$Chrome[train$browser=="Chrome"] <- 1
train$Chrome[train$browser!="Chrome"] <- 0
train$Safari[train$browser=="Safari"] <- 1
train$Safari[train$browser!="Safari"] <- 0
train$Firefox[train$browser=="Firefox"] <- 1
train$Firefox[train$browser!="Firefox"] <- 0
train$IE[train$browser=="Internet Explorer"] <- 1
train$IE[train$browser!="Internet Explorer"] <- 0
train$OtherBrowser[train$browser!="Chrome" & train$browser!="Safari" & train$browser!="Firefox" & train$browser!="Internet Explorer"] <- 1
train$OtherBrowser[train$browser=="Chrome" | train$browser=="Safari" | train$browser=="Firefox" | train$browser=="Internet Explorer"] <- 0
train$browser <- NULL
is.factor(train$browser)
contrasts(train$browser)
a<-table(train$browser)/sum(table(train$browser))
head(sort(a,decreasing = T))
head(sort(table(train$browser),decreasing = T))
length(unique(train$browser))
#operating system: Android, Macintosh, Windows, IOS, Chrome OS, Linux, Others
train$OS_Android[train$operatingSystem=="Android"] <- 1
train$OS_Android[train$operatingSystem!="Android"] <- 0
train$OS_Macintosh[train$operatingSystem=="Macintosh"] <- 1
train$OS_Macintosh[train$operatingSystem!="Macintosh"] <- 0
train$OS_Windows[train$operatingSystem=="Windows"] <- 1
train$OS_Windows[train$operatingSystem!="Windows"] <- 0
train$OS_iOS[train$operatingSystem=="iOS"] <- 1
train$OS_iOS[train$operatingSystem!="iOS"] <- 0
train$OS_ChromeOS[train$operatingSystem=="Chrome OS"] <- 1
train$OS_ChromeOS[train$operatingSystem!="Chrome OS"] <- 0
train$OS_Linux[train$operatingSystem=="Linux"] <- 1
train$OS_Linux[train$operatingSystem!="Linux"] <- 0
train$OS_Others[train$operatingSystem!="Android" & train$operatingSystem!="Macintosh" & train$operatingSystem!="Windows" & train$operatingSystem!="iOS" & train$operatingSystem!="Chrome OS" & train$operatingSystem!="Linux"] <- 1
train$OS_Others[train$operatingSystem=="Android" | train$operatingSystem=="Macintosh" | train$operatingSystem=="Windows" | train$operatingSystem=="iOS" | train$operatingSystem=="Chrome OS" | train$operatingSystem=="Linux"] <- 0
train$operatingSystem <- NULL
unique(train$OtherOS)
is.factor(train$operatingSystem)
contrasts(train$operatingSystem)

table(train$OS_Linux)
table(train$OS_ChromeOS)

#device category
train$desktop[train$deviceCategory=="desktop"] <- 1 
train$desktop[train$deviceCategory!="desktop"] <- 0
train$mobile[train$deviceCategory=="mobile"] <- 1 
train$mobile[train$deviceCategory!="mobile"] <- 0
train$tablet[train$deviceCategory=="tablet"] <- 1 
train$tablet[train$deviceCategory!="tablet"] <- 0
train$deviceCategory <- NULL
table(train$deviceCategory)/sum(table(train$deviceCategory))

sum(is.na(train$Linux)==T)

#country

train$country[train$country=="(not set)"]<-"United States"
train_country<-aggregate(train$revenue, by=list(Category=train$country), FUN=sum)
library(dummies)
country.new<-dummy(train$country,sep='_')
train<-cbind(train,country.new)
names(train)[231]<-'UK'
names(train)[232]<-'US'
train$CtryOthers[
  train$country!="US" & 
    train$country != "Canada" & 
    train$country != "Venezuela" & 
    train$country != "Japan" & 
    train$country != "Australia" & 
    train$country != "Mexico" & 
    train$country != "UK" & 
    train$country != "India" & 
    train$country != "Indonesia" & 
    train$country != "Taiwan" ]<-1
unique(train$CtryOthers)
train$CtryOthers[is.na(train$CtryOthers==T)]<-0
table(train$country_Venezuela)/sum(table(train$country))
library(dummies)
levels(train$country) <- c(levels(train$country),"Others","US", "HK", "UK","PuertoRico","SouthKorea","SaudiArabia","SouthAfrica","NewZealand", "St.Lucia")
train$country[train$country=="(not set)"] <- "Others"
train$country[is.na(train$country)==T] <- "Others"

train$country[train$country=="United States"] <- "US"
train$country[train$country=="Hong Kong"] <- "HK"
train$country[train$country=="South Korea"] <- "SouthKorea"
train$country[train$country=="Puerto Rico"] <- "PuertoRico"
train$country[train$country=="Saudi Arabia"] <- "SaudiArabia"
train$country[train$country=="New Zealand"] <- "NewZealand"
train$country[train$country=="St. Lucia"] <- "St.Lucia"
train$country[train$country!="US"&train$country!="Canada"&train$country!="Japan"& train$country!="Venezuela"
              & train$country!="Kenya"& train$country!="Australia"& train$country!="HK"& train$country!="Taiwan"
              & train$country!="Indonesia"& train$country!="Mexico"& train$country!="India"& train$country!="UK"
              & train$country!="Belgium"& train$country!="PuertoRico"& train$country!="Singapore"
              & train$country!="SouthKorea"& train$country!="Ukraine"& train$country!="Spain"& train$country!="Brazil"
              & train$country!="Germany"& train$country!="Colombia"& train$country!="France"& train$country!="Kuwait"
              & train$country!="Ecuador"& train$country!="China"& train$country!="Argentina"& train$country!="Greece"
              & train$country!="Chile"& train$country!="Italy"& train$country!="Peru"& train$country!="SaudiArabia"
              & train$country!="Turkey"& train$country!="Romania"& train$country!="Sweden"& train$country!="Cyprus"
              & train$country!="Switzerland"& train$country!="Nicaragua"& train$country!="Russia"& train$country!="Guatemala"
              & train$country!="Finland"& train$country!="Philippines"& train$country!="Pakistan"& train$country!="Poland"
              & train$country!="SouthAfrica"& train$country!="Egypt"& train$country!="Ireland"& train$country!="NewZealand"
              & train$country!="Israel"& train$country!="Malaysia"& train$country!="Armenia"& train$country!="Netherlands"
              & train$country!="Thailand"& train$country!="Kazakhstan"& train$country!="St. Lucia"] <- "Others"
temp <- dummy(train$country, sep = "_")
train <- cbind(temp,train)
train$country <- NULL


#city
train_city<-aggregate(train$revenue, by=list(Category=train$city), FUN=sum)
library(dummies)
city.new<-dummy(train$city,sep='_')
train<-cbind(train,city.new)
train$city_MountainView[train$city=="Mountain View"] <- 1
train$city_MountainView[train$city!="Mountain View"] <- 0
train$city_NewYork[train$city=="New York"] <- 1
train$city_NewYork[train$city!="New York"] <- 0
train$city_SanFrancisco[train$city=="San Francisco"] <- 1
train$city_SanFrancisco[train$city!="San Francisco"] <- 0
train$city_others[train$city=="Mountain View" | train$city=="New York"|train$city=="San Francisco"] <- 0
train$city_others[train$city!="Mountain View"& train$city!="New York" & train$city!="San Francisco"] <- 1
unique(train$city)


train$isTrueDirect[train$isTrueDirect=="TRUE"] <- 1
train$isTrueDirect[train$isTrueDirect=="FALSE"|is.na(train$isTrueDirect)==T] <- 0
unique(train$isTrueDirect)

train$newVisits[train$newVisits==1]<-1
train$newVisits[train$newVisit!=1| is.na(train$newVisits)==T]<-0
table(train$newVisits)

train$isMobile[train$isMobile=="TRUE"] <- 1
train$isMobile[train$isMobile!="FALSE"|is.na(train$isMobile)==0] <- 0


train$revenue<-log(train$transactionRevenue+1)
train$pageviews[is.na(train$pageviews)==T] <- 1



#constrast hours
class(train$visitStartTime) = c('POSIXt','POSIXct')
head(train$visitStartTime)
train$hour<-as.POSIXlt(train$visitStartTime)$hour
summary(train$hour)


table(train$campaign)

#campaign
train$Campaign[train$campaign=="(not set)"|is.na(train$campaign)==T] <-0
train$Campaign[train$campaign!="(not set)"] <-1
table(train$Campaign)



interpretation<-lm(revenue~OrganicSearch+ Social+ Direct+ Referral+ PaidSearch+ Affiliates+
                     qrt1 +qrt2 +qrt3+visitNumber+factor(hour)+
                     Chrome + Safari +Firefox + IE+
                     Android +Macintosh + Windows + IOS +ChromeOS+Linux+
                     deviceCategory+pageviews+I(pageviews^2)+newVisits+Campaign+
                     +US+country_Canada+country_Venezuela+country_Japan+country_Australia+country_Mexico+UK+country_India+country_Indonesia+country_Taiwan
                   +city_MountainView+city_NewYork+city_SanFrancisco
                    ,
                   data=train)
summary(interpretation)

interpretation<-lm(revenue~ hour+I(hour^2)+visitNumber+pageviews+I(pageviews^2)+newVisits+deviceCategory+channelGrouping+qrt1 +qrt2 +qrt3 +Chrome + Safari +Firefox + IE
                   +US+country_Canada+country_Venezuela+country_Japan+country_Australia+country_Mexico+UK+country_India+country_Indonesia+country_Taiwan
                   +city_MountainView+city_NewYork+city_SanFrancisco,data=train)
summary(interpretation)


inter<-lm(revenue~country_Argentina+country_Armenia+country_Australia+country_Belgium+country_Brazil+country_Canada+country_Chile+country_China+country_Colombia+country_Cyprus+country_Ecuador+country_Egypt+country_Finland+country_France+country_Germany+
            country_Greece+country_Guatemala+country_India+country_Indonesia+country_Ireland+country_Israel+country_Italy+country_Japan+country_Kazakhstan+country_Kenya+country_Kuwait+country_Malaysia+country_Mexico+country_Netherlands+country_Nicaragua+
            country_Pakistan+country_Peru+country_Philippines+country_Poland+country_Romania+country_Russia+country_Singapore+country_Spain+country_Sweden+country_Switzerland+country_Taiwan+country_Thailand+country_Turkey+country_Ukraine+country_Venezuela+
            country_Others+country_US+country_HK+country_PuertoRico+country_SouthKorea+country_SaudiArabia
            +visitNumber+factor(hour)+pageviews+I(pageviews^2)
          +OrganicSearch+Social+Direct+Referral+PaidSearch+Affiliates
          +Chrome+Safari+Firefox+IE
          +city_MountainView+city_NewYork+city_SanFrancisco
          +Android+Macintosh+Windows+IOS+ChromeOS+Linux+Campaign
          ,data=train)
summary(inter)

inter<-lm(revenue~country_US+country_Kenya+country_HK+country_Canada+country_Venezuela+
            country_Japan+country_Australia+country_Mexico+country_India+country_Indonesia+country_Taiwan
          +visitNumber+pageviews+I(pageviews^2)+factor(hour)
          +OrganicSearch+Social+Direct+Referral+PaidSearch+Affiliates
          +Chrome+Safari+Firefox+IE
          +city_MountainView+city_NewYork+city_SanFrancisco
          +OS_Android+OS_Macintosh+OS_Windows+OS_iOS
          +OS_ChromeOS+OS_Others
          +newVisits
          +mobile+desktop
          ,data=train)
summary(inter)

inter3<-lm(revenue~country_US+country_Kenya+country_HK+country_Canada+country_Venezuela+
            country_Japan+country_Australia+country_Mexico+country_India+country_Indonesia+country_Taiwan
          +visitNumber+pageviews+I(pageviews^2)+factor(hour)
          +OrganicSearch+Social+Direct+Referral+PaidSearch+Affiliates
          +Chrome+Safari+Firefox+IE
          +city_MountainView+city_NewYork+city_SanFrancisco
          +newVisits
          +mobile+desktop
          ,data=train)
summary(inter3)

inter1<-lm(revenue~country_US+country_Kenya+country_HK+country_Canada+country_Venezuela+country_Japan+country_Australia+country_Mexico+country_India+country_Indonesia+country_Taiwan
          +visitNumber+pageviews+I(pageviews^2)+factor(hour)
          +OrganicSearch+Social+Direct+Referral+PaidSearch+Affiliates
          +Chrome+Safari+Firefox+IE
          +city_MountainView+city_NewYork+city_SanFrancisco
          +operatingSystem+Campaign+newVisits
          +mobile+desktop
          +qrt1+qrt3+qrt2
          ,data=train)
summary(inter1)
plot(inter1)

table(train$country_Kenya)

train_city<-aggregate(train$transactionRevenue, by=list(Category=train$city), FUN=sum)
View(train_city)

table(train$OS_ChromeOS)
table(train$OS_Linux)

sum(train$transactionRevenue)
a<-273547637578/290395647934
