
library(data.table)
library(Metrics)


download.file(url="https://www.kaggle.com/c/psu-stat-380-house-prices/data/Stat_380_test.csv",destfile='./project/volume/models/data/raw/Stat_380_test.csv', method='curl')
download.file(url="https://www.kaggle.com/c/psu-stat-380-house-prices/data/Stat_380_train",destfile='./project/volume/models/data/raw/Stat_380_train.csv', method='curl')


# Create the test dataframe

DT<-fread('./project/volume/models/data/raw/Stat_380_train.csv')
train<-DT[!is.na(DT$SalePrice)]
DT2<-fread('./project/volume/models/data/raw/Stat_380_test.csv')
test<-DT2[!is.na(DT2$SalePrice)]

# make a null model

avg_price<-mean(train$SalePrice)

test$Null_model<-avg_price


# get root mean squared error
rmse(test$SalePrice,test$Null_model)


#group by BldgType first to make a little more interesting model

type_price<-train[,.(ap_avg_price=mean(SalePrice)),by=BldgType]

setkey(type_price,BldgType)
setkey(test,BldgType)

test<-merge(test,type_price, all.x=T)


# get rmse
rmse(test$DepDelay,test$ap_avg_price)


# make a submit file
fwrite(test[,.(ap_avg_price)],"./project/volume/models/data/processed/submit.csv")