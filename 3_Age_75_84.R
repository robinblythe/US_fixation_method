#Simulator can take:
## agegroups c("age_65", "age_75", or "age_85") and
## modelgroup c("HA_cemented", "HA_cementless", "THA_cemented", "THA_cementless)

# Age 75-84

# Baseline
baseline_75 <- list(
  HA_cemented_75 = simulator(n = prev$n_75_HA_cemented, agegroup = "age_75", modelgroup = "HA_cemented"),
  HA_cementless_75 = simulator(n = prev$n_75_HA_cementless, agegroup = "age_75", modelgroup = "HA_cementless"),
  THA_cemented_75 = simulator(n = prev$n_75_THA_cemented, agegroup = "age_75", modelgroup = "THA_cemented"),
  THA_cementless_75 = simulator(n = prev$n_75_THA_cementless, agegroup = "age_75", modelgroup = "THA_cementless")
)

# All cemented
cemented_75 <- list(
  HA = simulator(n = (prev$n_75_HA_cemented + prev$n_75_HA_cementless), agegroup = "age_75", modelgroup = "HA_cemented"),
  THA = simulator(n = (prev$n_75_THA_cemented + prev$n_75_THA_cementless), agegroup = "age_75", modelgroup = "THA_cemented")
)

cementless_75 <- list(
  HA = simulator(n = (prev$n_75_HA_cemented + prev$n_75_HA_cementless), agegroup = "age_75", modelgroup = "HA_cementless"),
  THA = simulator(n = (prev$n_75_THA_cemented + prev$n_75_THA_cementless), agegroup = "age_75", modelgroup = "THA_cementless")
)

#Obtain differences between model and baseline for each group; store in tibble
model_75_84 <- rbind(
  modeller(agegroup = 75, arthroplasty = "HA", fixation = "cemented"),
  modeller(agegroup = 75, arthroplasty = "HA", fixation = "cementless"),
  modeller(agegroup = 75, arthroplasty = "THA", fixation = "cemented"),
  modeller(agegroup = 75, arthroplasty = "THA", fixation = "cementless")
)

remove(baseline_75, cemented_75, cementless_75)