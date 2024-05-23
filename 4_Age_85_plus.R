#Simulator can take:
## agegroups c("age_65", "age_75", or "age_85") and
## modelgroup c("HA_cemented", "HA_cementless", "THA_cemented", "THA_cementless)

# Age 85+

# Baseline
baseline_85 <- list(
  HA_cemented_85 = simulator(n = prev$n_85_HA_cemented, agegroup = "age_85", modelgroup = "HA_cemented"),
  HA_cementless_85 = simulator(n = prev$n_85_HA_cementless, agegroup = "age_85", modelgroup = "HA_cementless"),
  THA_cemented_85 = simulator(n = prev$n_85_THA_cemented, agegroup = "age_85", modelgroup = "THA_cemented"),
  THA_cementless_85 = simulator(n = prev$n_85_THA_cementless, agegroup = "age_85", modelgroup = "THA_cementless")
)

# All cemented
cemented_85 <- list(
  HA = simulator(n = (prev$n_85_HA_cemented + prev$n_85_HA_cementless), agegroup = "age_85", modelgroup = "HA_cemented"),
  THA = simulator(n = (prev$n_85_THA_cemented + prev$n_85_THA_cementless), agegroup = "age_85", modelgroup = "THA_cemented")
)

cementless_85 <- list(
  HA = simulator(n = (prev$n_85_HA_cemented + prev$n_85_HA_cementless), agegroup = "age_85", modelgroup = "HA_cementless"),
  THA = simulator(n = (prev$n_85_THA_cemented + prev$n_85_THA_cementless), agegroup = "age_85", modelgroup = "THA_cementless")
)

#Obtain differences between model and baseline for each group; store in tibble
model_85_plus <- rbind(
  modeller(agegroup = 85, arthroplasty = "HA", fixation = "cemented"),
  modeller(agegroup = 85, arthroplasty = "HA", fixation = "cementless"),
  modeller(agegroup = 85, arthroplasty = "THA", fixation = "cemented"),
  modeller(agegroup = 85, arthroplasty = "THA", fixation = "cementless")
)

remove(baseline_85, cemented_85, cementless_85)