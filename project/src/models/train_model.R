
library(data.table)
library(Metrics)
library(caret)



# Create the test dataframe

DT<-fread('./project/volume/models/data/raw/Stat_380_train.csv')
train<-DT[!is.na(DT$SalePrice)]
DT2<-fread('./project/volume/models/data/raw/Stat_380_test.csv')
test<-DT2


# Wrangle train to be more similar to test

train.m1 <- melt(train, id.vars=c("Id"), measure.vars=c("BldgType1Fam", "BldgType2fmCon", "BldgTypeDuplex", "BldgTypeTwnhs", "BldgTypeTwnhsE"))
train.m1 <- subset(train.m1, value=="1")
setorder(train.m1, Id, na.last=FALSE)



# make a null model

avg_price<-mean(train$SalePrice)

test$Null_model<-avg_price


# get root mean squared error
rmse(train$SalePrice,test$Null_model)

# create submission dataframe
submit <- test[,.(Id, Null_model)]
names(submit)[names(submit) == "Null_model"] = "SalePrice"


# Begin working on lm model

set.seed(77)

train_y <- train$SalePrice


dummies <- dummyVars(SalePrice ~ ., data=train)
train <- predict(dummies, newdata = train)

# reformat and add back response

train <- data.table(train)
train$SalePrice <- train_y
test <- data.table(test)


# fit a linear model

lm_model <- lm(SalePrice ~., data=train)

# save the model

saveRDS(dummies,"./project/volume/models/SalePrice_lm.dummies")
saveRDS(lm_model,"./project/volume/models/SalePrice_lm.model")

test$pred<-predict(lm_model,newdata = test)



# create submit.csv 

fwrite(submit,"./project/volume/models/data/processed/submit.csv")