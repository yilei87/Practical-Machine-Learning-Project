library(caret)
library(rpart)
library(rpart.plot)
library(dplyr)
library(randomForest)

pmlTrain <-read.csv("C:/coursera/ML/pml-training.csv", header = TRUE)
str(pmlTrain)

pmlTest <-read.csv("C:/coursera/ML/pml-testing.csv", header = TRUE)
str(pmlTest)

pmlTrainSub <- select(pmlTrain,8:160)
pmlTestSub <- select(pmlTest,8:160)
pmlTrainSub2 <- pmlTrainSub[apply(pmlTestSub, 2, function(x) sum(is.na(x))) == 0]
pmlTestSub2 <- pmlTestSub[apply(pmlTestSub, 2, function(x) sum(is.na(x))) == 0]

set.seed(125)
inTrain = createDataPartition(pmlTrainSub2$classe, p = .75)[[1]]
training = pmlTrainSub2[ inTrain,]
testing = pmlTrainSub2[-inTrain,]

nrow(pmlTrainSub2)
nrow(training)
nrow(testing)
str(training)

cartModel <- rpart(classe ~ ., data = training, method = 'class', xval = 5)
print(cartModel)

#rpart.plot(cartModel)

predictionsCart <- predict(cartModel, testing, type = "class")
confusionMatrix(predictionsCart, testing$classe)

rfModel <- randomForest(classe ~ ., data = training)
print(rfModel)

predictionsRF <- predict(rfModel, testing, type = "class")
confusionMatrix(predictionsRF, testing$classe)

finalPredictions <- predict(rfModel, pmlTestSub2)

