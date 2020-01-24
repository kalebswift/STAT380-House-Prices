library(data.table)
library(Metrics)

DT <- fread("./project/volume/models/data/raw/Stat_380_train.csv")


#subset only rows with values for SalePrice. (pull from GitHub)
train <- DT[!is.na(DT$SalePrice)]

avg_price <- mean(train$SalePrice)

test$null_guess <- avg_price

test

# finish the below line of code
#delay_tab <- train[,.(avg_price = mean(SalePrice)), by

new_test_tab <- merge(test, price_tab, all.x=T)
