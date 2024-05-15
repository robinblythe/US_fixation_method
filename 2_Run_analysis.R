gc()
options(scipen = 100, digits = 5)

library(tidyverse)

# Model inputs
iter <- 10000 #define number of iterations
discount <- 0.03 #define discount rate
set.seed(888) #repeatability
source("./99_Parameters_old.R") #call parameter function (old)

#Number of patients in each group
n_65_HA_cemented <- 384 + 292
n_65_HA_cementless <- 20 + 45
n_65_THA_cemented <- 718
n_65_THA_cementless <- 335
n_75_HA_cemented <- 1142 + 685
n_75_HA_cementless <- 64 + 115
n_75_THA_cemented <- 491
n_75_THA_cementless <- 177
n_85_HA_cemented <- 1598 + 761
n_85_HA_cementless <- 83 + 121
n_85_THA_cemented = 163
n_85_THA_cementless = 64
  
# Simulator can take:
## agegroups c("age_65", "age_75", or "age_85") and 
## modelgroup c("HA_cemented", "HA_cementless", "THA_cemented", "THA_cementless)
df <- simulator(n = (384 + 292), agegroup = "age_65", modelgroup = "HA_cemented")
