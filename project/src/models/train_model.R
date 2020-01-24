library(data.table)
install.packages("Metrics")
library(Metrics)

DT <- fread("./project/volume/models/data/raw/Stat_380_train.cscv")

#subset only rows with values for SalePrice. (pull from GitHub)
sub_DT <- DT[!is.na(DT$SalePrice)][,.(Origin, DepDelay)]

rand_idx <- sample(1:nrow(sub_DT), 1000000)

train <- sub_DT[!rand_idx]

avg_delay <- mean(train$DepDelay)

