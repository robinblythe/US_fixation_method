# Enter parameters using US data
# All costs updated to USD 2019

# Number of patients in each group, US data
prev <- list(
  n_65_HA_cemented = 447,
  n_65_HA_cementless = 705,
  n_65_THA_cemented = 106,
  n_65_THA_cementless = 656,
  n_75_HA_cemented = 1395,
  n_75_HA_cementless = 1667,
  n_75_THA_cemented = 131,
  n_75_THA_cementless = 563,
  n_85_HA_cemented = 2148,
  n_85_HA_cementless = 1991,
  n_85_THA_cemented = 121,
  n_85_THA_cementless = 281
)

# Initial generic measures
# Cementless screws are $53ea; 55% use no screws, 24% use one, and 21% use two.
type_surg <- rdirichlet(iter, c(0.55, 0.24, 0.21))

# Cost per minute OT time in the USA, updated 2022 -> 2019 from https://doi.org/10.55576/job.v2i4.23
# All procedure costs are now cost/minute * number of minutes + add-ons (e.g. cement)
cost_min_OT <- rgamma(iter, shape = 2.030470639, scale = 22.674546047) / (1 + discount)^3

# Revision surgery cost from https://doi.org/10.1016/j.arth.2023.04.050
# Recreate cost distribution
base_cost_revisions <- c(rep(17686, 417), 
                         rep(11125, 145), 
                         rep(9066, 58), 
                         rep(16553, 53), 
                         rep(18374, 30), 
                         rep(8677, 28), 
                         rep(8427, 26), 
                         rep(12743, 11),
                         rep(13375, 7),
                         rep(10710, 6),
                         rep(10474, 6),
                         rep(13244, 3),
                         9745,
                         15360, 
                         10427)


generic <- list(

  # Procedure costs = cost per minute times number of minutes. Mean duration so use rnorm
  cost_HA = cost_min_OT * rnorm(iter, 78.45, 0.385),
  cost_THA = cost_min_OT * rnorm(iter, 92.93, 0.891),

  # Cost of cementing
  # Extra theatre time from original study, https://doi.org/10.1002/14651858.CD001706.pub4
  cost_cementing = rgamma(iter, shape = 32.478, scale = 0.223) * # Number of minutes taken to apply cement
    cost_min_OT + # Cost per minute
    (181 * 2 + runif(iter, min = 85, max = 115)) / (1 + discount)^5, # 2024 cost of cementing products, 2 packs antibiotic cement plus mixing tower

  cost_cementless = (type_surg[, 2] * 53 + type_surg[, 3] * 53 * 2) / (1 + discount)^1, # cost of cementless screws, 2024

  # HA is a weighted average, 65% bipolar, 35% monopolar
  cost_HA_prosthesis = (0.65 * rtri(iter, min = 1715, mode = 2385, max = 3066) + # Bipolar
    0.35 * rtri(iter, min = 1326, mode = 1658, max = 1991)) / (1 + discount)^1, # Monopolar

  # THA assumes ceramic head, same price for cemented and cementless prostheses
  cost_THA_prosthesis = list(
    cemented = rtri(iter, min = 3965, mode = 4388, max = 4811),
    cementless = rtri(iter, min = 4003, mode = 4776, max = 6375) / (1 + discount)^3),

  
  # Taking the top 8 indications leads to a median of 
  cost_revision = rnorm(iter, mean = mean(base_cost_revisions), sd = sd(base_cost_revisions)/sqrt(length(base_cost_revisions))),


  # Dislocation outcomes from https://doi.org/10.1016/j.arth.2018.05.015
  # Turning costs from normal to gamma using https://doi.org/10.31219/osf.io/zf62e
  # Study data is from 2018 so bring it up to $2019
  cost_dislocation_1year = rgamma(iter, shape = 9.55337, scale = 1819.09726) * (1 + discount),

  # Dislocation rates from original study
  dislocation_rate = list(
    HA_cemented = rbeta(iter, 2, 67),
    HA_cementless = rbeta(iter, 24, 280),
    THA_cemented = rbeta(iter, 32, 1257),
    THA_cementless = rbeta(iter, 15, 328)
  ),
  dislocation_utility = rbeta(iter, 9.77, 15.95),
  revision_utility = rbeta(iter, 36.94, 68.59),
  stable_HA_cemented_utility_followup = rbeta(iter, 97.97326, 50.47107),
  stable_HA_cementless_utility_followup = rbeta(iter, 48.65102, 35.23005),
  stable_THA_cemented_utility_followup = rbeta(iter, 5468.776, 1921.462),
  stable_THA_cementless_utility_followup = rbeta(iter, 5526.679, 2044.114)
)


# Transition probabilities
# For values at or near 0, use an approximation: Beta(100, 100000) which is ~0.001
transitions <- list(

  # Mortality rate UPDATED
  death = list(
    age_65 = list(
      year1 = rbeta(iter, 258389.8435, 3405003.936),
      year2 = rbeta(iter, 254561.8513, 3408832.008),
      year3 = rbeta(iter, 166517.9514, 3496876.976),
      year4 = rbeta(iter, 15311.98842, 3648081.256),
      year5 = rbeta(iter, 5742.004799, 3657657.102)
    ),
    age_75 = list(
      year1 = rbeta(iter, 1682688.309, 12424850.29),
      year2 = rbeta(iter, 1506154.818, 12601370.11),
      year3 = rbeta(iter, 1190652.136, 12916885.47),
      year4 = rbeta(iter, 153996.3315, 13953570.1),
      year5 = rbeta(iter, 100, 100000) # No deaths?
    ),
    age_85 = list(
      year1 = rbeta(iter, 3700913.392, 16919758.65),
      year2 = rbeta(iter, 2897156.095, 17723511.35),
      year3 = rbeta(iter, 2047992.198, 18572700.86),
      year4 = rbeta(iter, 231590.2987, 20389028.23),
      year5 = rbeta(iter, 9081.998598, 20611596.89)
    )
  ),

  # Dislocation rate using same approach as original paper
  dislocation = list(
    HA_cemented = list(
      year1 = generic$dislocation_rate$HA_cemented,
      year2 = generic$dislocation_rate$HA_cemented + 0.005,
      year3 = generic$dislocation_rate$HA_cemented + 0.010,
      year4 = generic$dislocation_rate$HA_cemented + 0.015,
      year5 = generic$dislocation_rate$HA_cemented + 0.020
    ),
    HA_cementless = list(
      year1 = generic$dislocation_rate$HA_cementless,
      year2 = generic$dislocation_rate$HA_cementless + 0.005,
      year3 = generic$dislocation_rate$HA_cementless + 0.010,
      year4 = generic$dislocation_rate$HA_cementless + 0.015,
      year5 = generic$dislocation_rate$HA_cementless + 0.020
    ),
    THA_cemented = list(
      year1 = generic$dislocation_rate$THA_cemented,
      year2 = generic$dislocation_rate$THA_cemented + 0.005,
      year3 = generic$dislocation_rate$THA_cemented + 0.010,
      year4 = generic$dislocation_rate$THA_cemented + 0.015,
      year5 = generic$dislocation_rate$THA_cemented + 0.020
    ),
    THA_cementless = list(
      year1 = generic$dislocation_rate$THA_cementless,
      year2 = generic$dislocation_rate$THA_cementless + 0.005,
      year3 = generic$dislocation_rate$THA_cementless + 0.010,
      year4 = generic$dislocation_rate$THA_cementless + 0.015,
      year5 = generic$dislocation_rate$THA_cementless + 0.020
    )
  ),

  # Revision rate UPDATED TO US DATA
  revision = list(
    age_65 = list(
      HA_cemented = list(
        year1 = rbeta(iter, 4022.98063, 195785.0572),
        year2 = rbeta(iter, 3128.984212, 196679.0071),
        year3 = rbeta(iter, 446.9977653, 199361.0002),
        year4 = rbeta(iter, 100, 100000),
        year5 = rbeta(iter, 446.9977653, 199361.0002)
      ),
      HA_cementless = list(
        year1 = rbeta(iter, 19739.95872, 477284.0013),
        year2 = rbeta(iter, 4229.989466, 492793.7727),
        year3 = rbeta(iter, 1409.997662, 495614.1839),
        year4 = rbeta(iter, 1409.997662, 495614.1839),
        year5 = rbeta(iter, 1409.997662, 495614.1839)
      ),
      THA_cemented = list(
        year1 = rbeta(iter, 211.981138, 11023.01919),
        year2 = rbeta(iter, 211.981138, 11023.01919),
        year3 = rbeta(iter, 100, 100000),
        year4 = rbeta(iter, 100, 100000),
        year5 = rbeta(iter, 100, 100000)
      ),
      THA_cementless = list(
        year1 = rbeta(iter, 16399.96538, 413935.1263),
        year2 = rbeta(iter, 2623.994514, 427711.1041),
        year3 = rbeta(iter, 2623.994514, 427711.1041),
        year4 = rbeta(iter, 100, 100000),
        year5 = rbeta(iter, 655.9975232, 429678.3901)
      )
    ),
    age_75 = list(
      HA_cemented = list(
        year1 = rbeta(iter, 30689.99116, 1915334.451),
        year2 = rbeta(iter, 5579.984955, 1940439.777),
        year3 = rbeta(iter, 8369.993462, 1937653.472),
        year4 = rbeta(iter, 1395.004476, 1944636.181),
        year5 = rbeta(iter, 1395.004476, 1944636.181)
      ),
      HA_cementless = list(
        year1 = rbeta(iter, 75014.9564, 2703872.426),
        year2 = rbeta(iter, 30005.96173, 2748879.502),
        year3 = rbeta(iter, 20003.99067, 2758883.709),
        year4 = rbeta(iter, 5000.998418, 2773887.079),
        year5 = rbeta(iter, 100, 100000)
      ),
      THA_cemented = list(
        year1 = rbeta(iter, 261.9847299, 16898.01505),
        year2 = rbeta(iter, 130.9923572, 17029.00641),
        year3 = rbeta(iter, 100, 100000),
        year4 = rbeta(iter, 100, 100000),
        year5 = rbeta(iter, 100, 100000)
      ),
      THA_cementless = list(
        year1 = rbeta(iter, 8444.971064, 308522.943),
        year2 = rbeta(iter, 1688.994903, 315279.0486),
        year3 = rbeta(iter, 562.9989436, 316405.4124),
        year4 = rbeta(iter, 100, 100000),
        year5 = rbeta(iter, 100, 100000)
      )
    ),
    age_85 = list(
      HA_cemented = list(
        year1 = rbeta(iter, 81623.92815, 4532276.019),
        year2 = rbeta(iter, 12887.95428, 4600999.659),
        year3 = rbeta(iter, 4296.008692, 4609617.31),
        year4 = rbeta(iter, 100, 100000),
        year5 = rbeta(iter, 100, 100000)
      ),
      HA_cementless = list(
        year1 = rbeta(iter, 93576.92565, 3870500.929),
        year2 = rbeta(iter, 27874.03801, 3936212.362),
        year3 = rbeta(iter, 23891.93647, 3940178.555),
        year4 = rbeta(iter, 3982.009343, 3960108.456),
        year5 = rbeta(iter, 1991.002133, 3962094.013)
      ),
      THA_cemented = list(
        year1 = rbeta(iter, 120.9917201, 14519.00643),
        year2 = rbeta(iter, 100, 100000),
        year3 = rbeta(iter, 100, 100000),
        year4 = rbeta(iter, 100, 100000),
        year5 = rbeta(iter, 100, 100000)
      ),
      THA_cementless = list(
        year1 = rbeta(iter, 561.9930449, 78398.03001),
        year2 = rbeta(iter, 561.9930449, 78398.03001),
        year3 = rbeta(iter, 280.9964006, 78678.9913),
        year4 = rbeta(iter, 100, 100000),
        year5 = rbeta(iter, 100, 100000)
      )
    )
  )
)

# Utilities are discounted under the premise that a QALY now is better than a QALY later
# Note QALYs not subject to inflation so no adjustment based on input year
utilities <- list(

  # Dislocation utility, same values as original paper
  dislocation = list(
    year1 = generic$dislocation_utility,
    year2 = generic$dislocation_utility / (1 + discount),
    year3 = generic$dislocation_utility / (1 + discount)^2,
    year4 = generic$dislocation_utility / (1 + discount)^3,
    year5 = generic$dislocation_utility / (1 + discount)^4
  ),

  # Revision utility, same values as original paper
  revision = list(
    year1 = generic$revision_utility,
    year2 = generic$revision_utility / 1 + discount,
    year3 = generic$revision_utility / (1 + discount)^2,
    year4 = generic$revision_utility / (1 + discount)^3,
    year5 = generic$revision_utility / (1 + discount)^4
  ),

  # Stable utility, same values as original paper
  HA_cemented = list(
    year1 = rbeta(iter, 95.3001, 63.5334),
    year2 = generic$stable_HA_cemented_utility_followup / (1 + discount),
    year3 = generic$stable_HA_cemented_utility_followup / (1 + discount)^2,
    year4 = generic$stable_HA_cemented_utility_followup / (1 + discount)^3,
    year5 = generic$stable_HA_cemented_utility_followup / (1 + discount)^4
  ),
  HA_cementless = list(
    year1 = rbeta(iter, 8.044704, 6.852896),
    year2 = generic$stable_HA_cementless_utility_followup / (1 + discount),
    year3 = generic$stable_HA_cementless_utility_followup / (1 + discount)^2,
    year4 = generic$stable_HA_cementless_utility_followup / (1 + discount)^3,
    year5 = generic$stable_HA_cementless_utility_followup / (1 + discount)^4
  ),
  THA_cemented = list(
    year1 = rbeta(iter, 5575.439, 2168.226),
    year2 = generic$stable_THA_cemented_utility_followup / (1 + discount),
    year3 = generic$stable_THA_cemented_utility_followup / (1 + discount)^2,
    year4 = generic$stable_THA_cemented_utility_followup / (1 + discount)^3,
    year5 = generic$stable_THA_cemented_utility_followup / (1 + discount)^4
  ),
  THA_cementless = list(
    year1 = rbeta(iter, 5615.287, 2293.568),
    year2 = generic$stable_THA_cementless_utility_followup / (1 + discount),
    year3 = generic$stable_THA_cementless_utility_followup / (1 + discount)^2,
    year4 = generic$stable_THA_cementless_utility_followup / (1 + discount)^3,
    year5 = generic$stable_THA_cementless_utility_followup / (1 + discount)^4
  )
)

costs <- list(

  # ALL COSTS UPDATED
  # Starting costs of surgery (no discounting required):
  # cost of procedure alone +
  # cost of additional cementing time +
  # cost of prosthesis
  HA_cemented =
    generic$cost_HA +
      generic$cost_cementing +
      generic$cost_HA_prosthesis,
  HA_cementless =
    generic$cost_HA +
      generic$cost_cementless +
      generic$cost_HA_prosthesis,
  THA_cemented =
    generic$cost_THA +
      generic$cost_cementing +
      generic$cost_THA_prosthesis$cemented,
  THA_cementless =
    generic$cost_THA +
      generic$cost_cementless +
      generic$cost_THA_prosthesis$cementless,


  # Dislocations
  cost_dislocation = list(
    year1 = generic$cost_dislocation_1year,
    year2 = generic$cost_dislocation_1year / (1 + discount),
    year3 = generic$cost_dislocation_1year / (1 + discount)^2,
    year4 = generic$cost_dislocation_1year / (1 + discount)^3,
    year5 = generic$cost_dislocation_1year / (1 + discount)^4
  ),

  # Revision surgery
  # Assume revision leads to same surgery type as initial procedure
  cost_revision = list(
    HA_cemented = list(
      year1 = (generic$cost_revision +
        generic$cost_cementing +
        generic$cost_HA_prosthesis),
      year2 = (generic$cost_revision +
        generic$cost_cementing +
        generic$cost_HA_prosthesis) / (1 + discount),
      year3 = (generic$cost_revision +
        generic$cost_cementing +
        generic$cost_HA_prosthesis) / (1 + discount)^2,
      year4 = (generic$cost_revision +
        generic$cost_cementing +
        generic$cost_HA_prosthesis) / (1 + discount)^3,
      year5 = (generic$cost_revision +
        generic$cost_cementing +
        generic$cost_HA_prosthesis) / (1 + discount)^4
    ),
    HA_cementless = list(
      year1 = (generic$cost_revision +
        generic$cost_cementless +
        generic$cost_HA_prosthesis),
      year2 = (generic$cost_revision +
        generic$cost_cementless +
        generic$cost_HA_prosthesis) / (1 + discount),
      year3 = (generic$cost_revision +
        generic$cost_cementless +
        generic$cost_HA_prosthesis) / (1 + discount)^2,
      year4 = (generic$cost_revision +
        generic$cost_cementless +
        generic$cost_HA_prosthesis) / (1 + discount)^3,
      year5 = (generic$cost_revision +
        generic$cost_cementless +
        generic$cost_HA_prosthesis) / (1 + discount)^4
    ),
    THA_cemented = list(
      year1 = (generic$cost_revision +
        generic$cost_cementing +
        generic$cost_THA_prosthesis$cemented),
      year2 = (generic$cost_revision +
        generic$cost_cementing +
        generic$cost_THA_prosthesis$cemented) / (1 + discount),
      year3 = (generic$cost_revision +
        generic$cost_cementing +
        generic$cost_THA_prosthesis$cemented) / (1 + discount)^2,
      year4 = (generic$cost_revision +
        generic$cost_cementing +
        generic$cost_THA_prosthesis$cemented) / (1 + discount)^3,
      year5 = (generic$cost_revision +
        generic$cost_cementing +
        generic$cost_THA_prosthesis$cemented) / (1 + discount)^4
    ),
    THA_cementless = list(
      year1 = (generic$cost_revision +
        generic$cost_cementless +
        generic$cost_THA_prosthesis$cementless),
      year2 = (generic$cost_revision +
        generic$cost_cementless +
        generic$cost_THA_prosthesis$cementless) / (1 + discount),
      year3 = (generic$cost_revision +
        generic$cost_cementless +
        generic$cost_THA_prosthesis$cementless) / (1 + discount)^2,
      year4 = (generic$cost_revision +
        generic$cost_cementless +
        generic$cost_THA_prosthesis$cementless) / (1 + discount)^3,
      year5 = (generic$cost_revision +
        generic$cost_cementless +
        generic$cost_THA_prosthesis$cementless) / (1 + discount)^4
    )
  )
)
