# Simulator can take:
## agegroups c("age_65", "age_75", or "age_85") and
## modelgroup c("HA_cemented", "HA_cementless", "THA_cemented", "THA_cementless)

# Age 65-74

# Baseline
baseline_65 <- list(
  HA_cemented_65 = simulator(n = prev$n_65_HA_cemented, agegroup = "age_65", modelgroup = "HA_cemented"),
  HA_cementless_65 = simulator(n = prev$n_65_HA_cementless, agegroup = "age_65", modelgroup = "HA_cementless"),
  THA_cemented_65 = simulator(n = prev$n_65_THA_cemented, agegroup = "age_65", modelgroup = "THA_cemented"),
  THA_cementless_65 = simulator(n = prev$n_65_THA_cementless, agegroup = "age_65", modelgroup = "THA_cementless")
)

# All cemented
cemented_65 <- list(
  HA = simulator(n = (prev$n_65_HA_cemented + prev$n_65_HA_cementless), agegroup = "age_65", modelgroup = "HA_cemented"),
  THA = simulator(n = (prev$n_65_THA_cemented + prev$n_65_THA_cementless), agegroup = "age_65", modelgroup = "THA_cemented")
)

cementless_65 <- list(
  HA = simulator(n = (prev$n_65_HA_cemented + prev$n_65_HA_cementless), agegroup = "age_65", modelgroup = "HA_cementless"),
  THA = simulator(n = (prev$n_65_THA_cemented + prev$n_65_THA_cementless), agegroup = "age_65", modelgroup = "THA_cementless")
)

# Obtain differences between model and baseline for each group; store in tibble
model_65_74 <- rbind(
  modeller(agegroup = 65, arthroplasty = "HA", fixation = "cemented"),
  modeller(agegroup = 65, arthroplasty = "HA", fixation = "cementless"),
  modeller(agegroup = 65, arthroplasty = "THA", fixation = "cemented"),
  modeller(agegroup = 65, arthroplasty = "THA", fixation = "cementless")
)

remove(baseline_65, cemented_65, cementless_65)
