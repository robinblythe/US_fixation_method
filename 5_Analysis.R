gc()
options(scipen = 100, digits = 5)

library(tidyverse)
library(EnvStats)
library(LaplacesDemon)
library(patchwork)

# Model inputs
iter <- 10000 # define number of iterations
discount <- 0.03 # define discount rate
WTP <- 50000
set.seed(888) # repeatability

# To discuss:
# Cost of prostheses - from word doc (Healthcare Econ Study cost data)
# Assumption for THA is ceramic heads only
# Cost/min of OT time and whether we should add an opportunity cost to this value
# Model structure - we assume all dislocations return to stable due to all-cause revision rate
# Same type of revision surgery and fixation outcome - works out OK from model perspective
# Same utility values as original paper - evidence suggests dislocation can lead to 1y of increased discomfort/cost
# Many probabilities == 0 in the revision data. Double check? I've approximated with Beta(100, 100000) and rounded up so min = 1
# Someone to run through R code?
# Add a total graphic - not split by age group



# Call parameters and functions required to populate models
source("./0_Parameters_US.R")
source("./1_Model_function.R")

# Run models for each age group and merge them together into one long dataframe
source("./2_Age_65_74.R")
source("./3_Age_75_84.R")
source("./4_Age_85_plus.R")

models <- rbind(
  model_65_74,
  model_75_84,
  model_85_plus
)

# Clear up environment
remove(
  costs, generic, prev, transitions, type_surg, utilities, cost_min_OT,
  simulator, modeller, model_65_74, model_75_84, model_85_plus
)
gc()

# Analysis summary
analysis <- models |>
  group_by(Strategy, Prosthesis, Age) |>
  summarise(
    Total_Cost_5y = mean(Costs),
    Total_QALY_5y = mean(QALYs),
    Pct_Cost_Saving = sum(Costs < 0) / iter,
    Pct_QALY_Gaining = sum(QALYs > 0) / iter,
    NMB = sum(mean(QALYs) * WTP - mean(Costs)),
    Pct_Cost_Effective = sum(QALYs * WTP - Costs > 0) / iter
  ) |>
  mutate(Total_Cost_5y = Total_Cost_5y * (1 + discount)^5) # Convert $2019 to $2024

p_ha <- models |>
  filter(Prosthesis == "Hemiarthroplasty") |>
  ggplot()
p_tha <- models |>
  filter(Prosthesis == "Total hip arthroplasty") |>
  ggplot()
p_all <- models |>
  ggplot()

p_all +
  geom_point(aes(x = QALYs, y = Costs, colour = Strategy), alpha = 0.2) +
  geom_abline(intercept = 0, slope = 50000) +
  theme_bw() +
  theme(panel.grid.minor = element_blank()) +
  scale_y_continuous(labels = scales::unit_format(prefix = "$", unit = "M", scale = 1e-6)) +
  labs(
    x = "QALYs",
    y = "Costs ($millions)",
    title = "All procedures"
  ) +
  p_ha +
  geom_point(aes(x = QALYs, y = Costs, colour = Strategy), alpha = 0.2) +
  geom_abline(intercept = 0, slope = 50000) +
  facet_wrap(vars(Age), ncol = 1) +
  theme_bw() +
  theme(panel.grid.minor = element_blank()) +
  scale_y_continuous(labels = scales::unit_format(prefix = "$", unit = "M", scale = 1e-6)) +
  labs(
    x = "QALYs",
    y = "Costs ($millions)",
    title = "Hemiarthroplasty"
  ) +
  p_tha +
  geom_point(aes(x = QALYs, y = Costs, colour = Strategy), alpha = 0.2) +
  geom_abline(intercept = 0, slope = 50000) +
  facet_wrap(vars(Age), ncol = 1) +
  theme_bw() +
  theme(panel.grid.minor = element_blank()) +
  scale_y_continuous(labels = scales::unit_format(prefix = "$", unit = "M", scale = 1e-6)) +
  labs(
    x = "QALYs",
    y = "Costs ($millions)",
    title = "Total hip arthroplasty"
  ) +
  plot_annotation(title = "Cost-effectiveness of setting default stem fixation") +
  plot_layout(guides = "collect") &
  theme(legend.position = "bottom")
