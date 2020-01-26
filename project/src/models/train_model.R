
library(data.table)
library(Metrics)


# Create the test dataframe

DT<-fread('./project/volume/models/data/raw/Stat_380_train.csv')
train<-DT[!is.na(DT$SalePrice)]
DT2<-fread('./project/volume/models/data/raw/Stat_380_test.csv')
test<-DT2

# make a null model

avg_price<-mean(train$SalePrice)

test$Null_model<-avg_price


# get root mean squared error
rmse(train$SalePrice,test$Null_model)


#group by BldgType first to make a little more interesting model

#type_price<-train[,.(ap_avg_price=mean(SalePrice)),by=BldgType]

#setkey(type_price,BldgType)
#setkey(test,BldgType)

#test<-merge(test,type_price, all.x=T)


# get rmse
#rmse(train$SalePrice,test$ap_avg_price)


# make a submit file
fwrite(test[,.(Id, Null_model)],"./project/volume/models/data/processed/submit.csv")