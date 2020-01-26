
library(data.table)
library(Metrics)


download.file(url="https://www.kaggle.com/c/psu-stat-380-house-prices/data/Stat_380_test.csv",destfile='./project/volume/models/data/raw/Stat_380_test.csv', method='curl')
download.file(url="https://www.kaggle.com/c/psu-stat-380-house-prices/data/Stat_380_train",destfile='./project/volume/models/data/rawStat_380_test.csv', method='curl')


# Create the test dataframe

DT<-fread('./project/volume/models/data/raw/Stat_380_train.csv')
test<-DT[!is.na(DT$SalePrice)]

# make a null model

avg_delay<-mean(train$DepDelay)

test$Null_model<-avg_delay


# using the metrics package here because my dataset isnt on kaggle, but this part would be done for you by submitting to the LB
rmse(test$DepDelay,test$Null_model)


#group by airport first to make a little more interesting model

origin_delay<-train[,.(ap_avg_delay=mean(DepDelay)),by=Origin]

setkey(origin_delay,Origin)
setkey(test,Origin)

test<-merge(test,origin_delay, all.x=T)


# using the metrics package here because my dataset isnt on kaggle, but this part would be done for you by submitting to the LB
rmse(test$DepDelay,test$ap_avg_delay)





# in my example I do not need to make a submit file, but if I did I would do something like this
fwrite(test[,.(ap_avg_delay)],"./project/volume/data/processed/submit.csv")