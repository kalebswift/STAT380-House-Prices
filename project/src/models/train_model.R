
library(data.table)
library(Metrics)
library(caret)



# Create the test dataframe

DT<-fread('./project/volume/data/raw/Stat_380_train.csv')
train<-DT[!is.na(DT$SalePrice)]
DT2<-fread('./project/volume/data/raw/Stat_380_test.csv')
test<-DT2

# Begin working on lm model

set.seed(77)

test$SalePrice <- 0

# fit a linear model

lm_model <- lm(SalePrice ~ LotArea + OverallQual + OverallCond + FullBath + HalfBath + YearBuilt + TotalBsmtSF + BedroomAbvGr + CentralAir + GrLivArea + YrSold, data=train)

# assess model

summary(lm_model)

# save the model

saveRDS(lm_model,"./project/volume/SalePrice_lm.model")

test$pred<-predict(lm_model,newdata = test)


# create submit.csv 

submit <- test[,.(Id, pred)]
names(submit)[names(submit) == "pred"] = "SalePrice"

fwrite(submit,"./project/volume/data/processed/submit.csv")
