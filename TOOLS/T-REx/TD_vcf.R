library(abind)
library(MASS)
library(glmnet)
library(rTensor)
#library(caret)
library(ranger)
#library(tidyverse)
#library(ggpubr)
library(abind)
library(liquidSVM)

set.seed(123) 

args = commandArgs(trailingOnly = TRUE)
infile <- as.numeric(args[1])
data1=infile

infile <- as.numeric(args[2])
sweep_train_sample=infile

infile <- as.numeric(args[3])
neut_train_sample=infile

infile <- as.numeric(args[4])
test_sample=infile

infile <- as.character(args[5])
input=infile

infile <- as.character(args[6])
output=infile

result_file <- file.path(output, "Results.txt")
#Reading Train data
start_time <- Sys.time()
added <- NULL
for (i in 1:as.numeric(sweep_train_sample))
{
  mean_sweep <- read.csv(paste0(input,"sweep_train_align_",i,".csv"), header = TRUE,  row.names = 1)
  dim(mean_sweep)
  #mean_sweep<-as.matrix(mean_sweep)
  added<-abind(added, mean_sweep, along = 3)
  print(i)
}
dim(added)



for (i in 1:neut_train_sample)
{
  mean_sweep <- read.csv(paste0(input,"neut_train_align_",i,".csv"), header = TRUE, row.names = 1)
  dim(mean_sweep)
  #mean_sweep<-as.matrix(mean_sweep)
  added<-abind(added, mean_sweep, along = 3)
  print(i)
}
dim(added)


add<-aperm(added, c(3,1,2))
dim(add)
end_time <- Sys.time()
execution_time <- as.numeric(difftime(end_time, start_time, units = "secs"))
cat(paste("Execution time of reading training data:", execution_time, "\n"), file = result_file, append = TRUE)



#Reading Test data
start_time <- Sys.time()
addd <- NULL
for (i in 1:test_sample)
{
  i
  mean_sweep <- read.csv(paste0(input,"test_",i,".csv"), header = TRUE, row.names = 1)
  dim(mean_sweep)
  #mean_sweep<-as.matrix(mean_sweep)
  addd<-abind(addd, mean_sweep, along = 3)
  print(i)
}
dim(addd)

ad<-aperm(addd, c(3,1,2))
end_time <- Sys.time()
execution_time <- as.numeric(difftime(end_time, start_time, units = "secs"))
cat(paste("Execution time of reading testing data:", execution_time, "\n"), file = result_file, append = TRUE)




# Center and scale tensor (see Rasmus Brow Tutorial on PARAFAC)
start_time <- Sys.time()
meansTrain <- matrix(NA, nrow = 64, ncol = 64) # One for each feature
sdsTrain <- c() # One for each observation
sdsTest <- c() # One for each observation

for(i in 1:(sweep_train_sample+neut_train_sample)) {
  sdsTrain[i] = sqrt(sum(add[i,,]^2))
  add[i,,] = add[i,,] / sdsTrain[i]
  
}
end_time <- Sys.time()
execution_time <- as.numeric(difftime(end_time, start_time, units = "secs"))
cat(paste("Execution time of processing training tensor data:", execution_time, "\n"), file = result_file, append = TRUE)

start_time <- Sys.time()
for(i in 1:test_sample) {
  
  sdsTest[i] = sqrt(sum(ad[i,,]^2))
  ad[i,,] = ad[i,,] / sdsTest[i]
}

for(j in 1:64) {
  for(k in 1:64) {
    meansTrain[j,k] = mean(add[,j,k])
    
    add[,j,k] = add[,j,k] - meansTrain[j,k]
    ad[,j,k] = ad[,j,k] - meansTrain[j,k]
  }
}
Ytrain <-data.frame(class = as.factor( c( rep("Sweep", sweep_train_sample), rep("Neutral", neut_train_sample) ) ) )
#Y<-data.frame(class = as.factor( c( rep("Sweep", sweep_test_sample), rep("Neutral", neut_test_sample) ) ) )
nrow(Ytrain)
ntrees = 5000
nrandsplits = 10
alphas <- seq(0, 1, by = 0.1)
length(alphas)
end_time <- Sys.time()
execution_time <- as.numeric(difftime(end_time, start_time, units = "secs"))
cat(paste("Execution time of processing testing tensor data:", execution_time, "\n"), file = result_file, append = TRUE)

# CP Tensor decomposition. 
start_time <- Sys.time()
max_rank_cp <-data1
deviances_cp <- c()
lambdas_cp <- c()
oob_errors_cp <- c()
cv_errors_cp_svm <- c()

cp_decomp <- cp(as.tensor(add), num_components = data1)
A <- cp_decomp$U[[1]]
A_path <- file.path(output, "A.csv")
write.csv(A,file=A_path)
B <- cp_decomp$U[[2]]
B_path <- file.path(output, "B.csv")
write.csv(B,file=B_path)
C <- cp_decomp$U[[3]]
C_path <- file.path(output, "C.csv")
write.csv(C,file=C_path)

Xtrain <- sweep( sweep( A, 2, colMeans(A) ), 2, FUN = "/", apply(A, 2, sd) )
colnames(Xtrain) = paste("Component", seq(1, ncol(Xtrain)), sep = "")

end_time <- Sys.time()
execution_time <- as.numeric(difftime(end_time, start_time, units = "secs"))
cat(paste("Tensor decomposition for training:", execution_time, "\n"), file = result_file, append = TRUE)

start_time <- Sys.time()
# ELASTIC-NET
for(aIndex in 1:length(alphas)) {
  cvfit <- cv.glmnet(Xtrain, as.matrix(Ytrain), family = "binomial", alpha = alphas[aIndex], nfolds = 10, type.measure = "deviance")
  
  deviances_cp[aIndex] = min(cvfit$cvm)
  
  lambdas_cp[aIndex] = cvfit$lambda.min
  
}


# RANDOM FOREST
trainData <- as.data.frame( cbind(Xtrain, Ytrain) )

rf_trained <- ranger(class ~., data = trainData, num.trees = ntrees, probability = TRUE, oob.error = TRUE)

oob_errors_cp[1] = rf_trained$prediction.error

#SVM max_gamma=100000
svm_trained <- mcSVM(x = Xtrain, y = Ytrain$class, mc_type = "OvA_hinge", folds = 10, scale = FALSE, do.select = TRUE, max_gamma=100000)

cv_errors_cp_svm[1] = mean(svm_trained$select_errors$val_error)




dim(deviances_cp)
est_rank_cp <- data1
est_rank_cp_rf<-data1
est_rank_cp_svm<-data1

est_alpha_cp <- alphas[ which(deviances_cp == min(deviances_cp), arr.ind = TRUE)]
est_alpha_cp_path <- file.path(output, "alpha.csv")
write.csv(est_alpha_cp,file=est_alpha_cp_path)


est_lambda_cp <- lambdas_cp[which(deviances_cp == min(deviances_cp), arr.ind = TRUE)]
est_lambda_cp_path <- file.path(output, "lambda.csv")
write.csv(est_lambda_cp,file=est_lambda_cp_path)

est_alpha_cp
est_lambda_cp

end_time <- Sys.time()
execution_time <- as.numeric(difftime(end_time, start_time, units = "secs"))
cat(paste("Execution time of training:", execution_time, "\n"), file = result_file, append = TRUE)

start_time <- Sys.time()
# TEST FOR ELASTIC NET
Atrain_cp <- cp_decomp$U[[1]]
B <- cp_decomp$U[[2]]
C <- cp_decomp$U[[3]]

lambda_matrix_inv <- diag(1/cp_decomp$lambdas)
mode1_unfolded <- k_unfold(as.tensor(ad), m = 1)@data


Atest_cp <- mode1_unfolded %*% khatri_rao(C, B) %*% ginv( (t(C)%*%C) * (t(B)%*%B ) ) %*% lambda_matrix_inv
Atest_cp_path <- file.path(output, "Atest_cp.csv")
write.csv(Atest_cp,file=Atest_cp_path)

Xtrain <- sweep( sweep( Atrain_cp, 2, colMeans(Atrain_cp) ), 2, FUN = "/", apply(Atrain_cp, 2, sd) )
fit_cp <- glmnet(Xtrain, as.matrix(Ytrain), family = "binomial", alpha = est_alpha_cp, lambda = est_lambda_cp)

X <- sweep( sweep( Atest_cp, 2, colMeans(Atrain_cp) ), 2, FUN = "/", apply(Atrain_cp, 2, sd) )
probs_est_cp <- predict(fit_cp, X, s = est_lambda_cp, type = "response")


probs_est_cp <- data.frame( Sweep = c(probs_est_cp),Neutral = 1-c(probs_est_cp)  )
probs_est_cp_path <- file.path(output, "Probs_EN.csv") 
write.csv(probs_est_cp,file=probs_est_cp_path)

Yest_cp <- data.frame("Class" = ifelse(probs_est_cp$Sweep >= 0.5, "Sweep", "Neutral"))
Yest_cp_path <- file.path(output, "Class_EN.csv")
write.csv(Yest_cp,file=Yest_cp_path)



#TEST FOR RANDOM FOREST.



X <- sweep( sweep( Atest_cp, 2, colMeans(Atrain_cp) ), 2, FUN = "/", apply(Atrain_cp, 2, sd) )
colnames(X) = paste("Component", seq(1, ncol(X)), sep = "")
preds <- predict(rf_trained, X)
preds_path <- file.path(output, "Probs_RF.csv")
write.csv(preds,file=preds_path)
probs_est_cp_rf <- as.data.frame(preds$predictions)


Yest_cp_rf <- data.frame("Class" = ifelse(probs_est_cp_rf$Neutral < 0.5, "Sweep", "Neutral"))
Yest_cp_rf_path <- file.path(output, "Class_RF.csv")
write.csv(Yest_cp_rf,file=Yest_cp_rf_path)




# TEST FOR SUPPORT VECTOR MACHINE


Xtrain <- sweep( sweep( Atrain_cp, 2, colMeans(Atrain_cp) ), 2, FUN = "/", apply(Atrain_cp, 2, sd) )
X <- sweep( sweep( Atest_cp, 2, colMeans(Atrain_cp) ), 2, FUN = "/", apply(Atrain_cp, 2, sd) )
preds <- c(predict(svm_trained, X))
pred_probs <- (preds + 1) / 2
pred_probs_path <- file.path(output, "Probs_SVM.csv")
write.csv(pred_probs,file=pred_probs_path)
probs_est_cp_svm <- data.frame("Sweep" = pred_probs, "Neutral" = 1-pred_probs)
Yest_cp_svm <- data.frame("Class" = ifelse(preds <= 0.5, "Neutral", "Sweep"))
pred_probs_path <- file.path(output, "Class_SVM.csv")
write.csv(Yest_cp_svm,file=pred_probs_path)

end_time <- Sys.time()
execution_time <- as.numeric(difftime(end_time, start_time, units = "secs"))
cat(paste("Execution time of testing:", execution_time, "\n"), file = result_file, append = TRUE)





