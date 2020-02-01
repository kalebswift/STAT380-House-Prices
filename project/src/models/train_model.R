
library(data.table)
library(Metrics)
library(caret)



# Create the test dataframe

DT<-fread('./project/volume/models/data/raw/Stat_380_train.csv')
train<-DT[!is.na(DT$SalePrice)]
DT2<-fread('./project/volume/models/data/raw/Stat_380_test.csv')
test<-DT2


# create submission dataframe
#submit <- test[,.(Id, Null_model)]
#names(submit)[names(submit) == "Null_model"] = "SalePrice"


# Begin working on lm model

set.seed(77)

train_y <- train$SalePrice
test$SalePrice <- 0


#dummies <- dummyVars(SalePrice ~ ., data=train)
dummies <- dummyVars(SalePrice ~ LotFrontage + LotArea + BldgType + OverallQual + OverallCond + FullBath + HalfBath + TotRmsAbvGrd + YearBuilt + TotalBsmtSF + BedroomAbvGr + Heating + CentralAir + GrLivArea + PoolArea + YrSold, data=train)


#train <- predict(dummies, newdata = train)
#test <- predict(dummies, newdata = test)

# reformat and add back response

#train <- data.table(train)
#train$SalePrice <- train_y
#test <- data.table(test)


# fit a linear model

lm_model <- lm(SalePrice ~ LotArea + OverallQual + OverallCond + FullBath + HalfBath + YearBuilt + TotalBsmtSF + BedroomAbvGr + CentralAir + GrLivArea + YrSold, data=train)

# assess model

summary(lm_model)

# save the model

#saveRDS(dummies,"./project/volume/models/SalePrice_lm.dummies")
saveRDS(lm_model,"./project/volume/models/SalePrice_lm.model")

test$pred<-predict(lm_model,newdata = test)


# create submit.csv 

submit <- test[,.(Id, pred)]
names(submit)[names(submit) == "pred"] = "SalePrice"

fwrite(submit,"./project/volume/models/data/processed/submit.csv")
