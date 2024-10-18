# Enter parameters using US data
# All costs updated to USD 2019

# Number of patients in each group, US data
prev <- list(
  n_65_HA_cemented = 565,
  n_65_HA_cementless = 925,
  n_65_THA_cemented = 138,
  n_65_THA_cementless = 815,
  n_75_HA_cemented = 1489,
  n_75_HA_cementless = 1847,
  n_75_THA_cemented = 169,
  n_75_THA_cementless = 649,
  n_85_HA_cemented = 2279,
  n_85_HA_cementless = 2077,
  n_85_THA_cemented = 131,
  n_85_THA_cementless = 255
)

# Initial generic measures
# Cementless screws are $53ea; 55% use no screws, 24% use one, and 21% use two.
type_surg <- rdirichlet(iter, c(0.55, 0.24, 0.21))

# Cost per minute OT time in the USA, updated 2022 -> 2019 from https://doi.org/10.55576/job.v2i4.23
# All procedure costs are now cost/minute * number of minutes + add-ons (e.g. cement)
cost_min_OT <- rgamma(iter, shape = 2.030, scale = 22.675) / (1 + discount)^3

# Estimate of proportion of revisions due to septic vs aseptic from https://doi.org/10.1016/j.arth.2018.05.008
aseptic_revision <- rbeta(iter, 702, 86)

generic <- list(

  # Primary procedure costs = cost per minute times number of minutes. Mean duration so use rnorm
  cost_HA = cost_min_OT * rnorm(iter, 78.400, 0.384),
  cost_THA = cost_min_OT * rnorm(iter, 92.682, 0.887),
  
  # Cost of revision from https://doi.org/10.1016/j.arth.2018.05.008
  # Weighted average based on aseptic vs infected revisions
  cost_revision = (aseptic_revision * rgamma(iter, shape = 1079.724, scale = 56.392) + 
    (1 - aseptic_revision) * rgamma(iter, shape = 142.787, scale = 639.616))*(1 + discount),
  
  # Cost of cementing
  # Extra theatre time from original study, https://doi.org/10.1002/14651858.CD001706.pub4
  cost_cementing = rgamma(iter, shape = 32.478, scale = 0.223) * # Number of minutes taken to apply cement
    cost_min_OT + # Cost per minute
    (181 * 2 + runif(iter, min = 85, max = 115)), # 2024 cost of cementing products, 2 packs antibiotic cement plus mixing tower

  cost_cementless = (type_surg[, 2] * 53 + type_surg[, 3] * 53 * 2) / (1 + discount)^1, # cost of cementless screws, 2024

  # HA is a weighted average, 65% bipolar, 35% monopolar
  cost_HA_prosthesis = (0.65 * rnorm(iter, mean = 2390.5, sd = 262.246) + # Bipolar
    0.35 * rnorm(iter, mean = 1658.5, sd = 129.085)) / (1 + discount)^1, # Monopolar

  # THA assumes ceramic head, same price for cemented and cementless prostheses
  cost_THA_prosthesis = list(
    cemented = rnorm(iter, mean = 4388, sd = 164.219),
    cementless = rgamma(iter, shape = 123.206, scale = 41.484) / (1 + discount)^3),

  # Dislocation outcomes from https://doi.org/10.1016/j.arth.2018.05.015
  # Turning costs from normal to gamma using https://doi.org/10.31219/osf.io/zf62e
  # Study data is from 2018 so bring it up to $2019
  cost_dislocation_1year = rgamma(iter, shape = 9.553, scale = 1819.097) * (1 + discount),

  # Dislocation rates from original study
  dislocation_rate = list(
    HA_cemented = rbeta(iter, 2, 67),
    HA_cementless = rbeta(iter, 24, 280),
    THA_cemented = rbeta(iter, 32, 1257),
    THA_cementless = rbeta(iter, 15, 328)
  ),
  dislocation_utility = rbeta(iter, 9.77, 15.95),
  revision_utility = rbeta(iter, 36.94, 68.59),
  stable_HA_cemented_utility_followup = rbeta(iter, 97.973, 50.471),
  stable_HA_cementless_utility_followup = rbeta(iter, 48.651, 35.230),
  stable_THA_cemented_utility_followup = rbeta(iter, 5468.776, 1921.462),
  stable_THA_cementless_utility_followup = rbeta(iter, 5526.679, 2044.114)
)


# Transition probabilities
# For values at or near 0, use an approximation: Beta(100, 100000) which is ~0.001
transitions <- list(

  # Mortality rate
  death = list(
    age_65 = list(
      year1 = rbeta(iter, 402765.061, 5555716.843),
      year2 = rbeta(iter, 446703.229, 5511780.825),
      year3 = rbeta(iter, 283156.148, 5675327.965),
      year4 = rbeta(iter, 46379.094, 5912113.994),
      year5 = rbeta(iter, 12205.009, 5946280.501)
    ),
    age_75 = list(
      year1 = rbeta(iter, 1855495.430, 15375290.994),
      year2 = rbeta(iter, 1838894.241, 15391918.387),
      year3 = rbeta(iter, 1515113.661, 15715672.114),
      year4 = rbeta(iter, 232456.400, 16998374.252),
      year5 = rbeta(iter, 8301.999, 17222497.531)
    ),
    age_85 = list(
      year1 = rbeta(iter, 3881878.849, 18528870.513),
      year2 = rbeta(iter, 3309066.057, 19101690.330),
      year3 = rbeta(iter, 2371734.983, 20039030.295),
      year4 = rbeta(iter, 364519.064, 22046302.395),
      year5 = rbeta(iter, 14202.001, 22396554.447)
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

  # Revision rate
  revision = list(
    age_65 = list(
      HA_cemented = list(
        year1 = rbeta(iter, 5075.986, 313019.131),
        year2 = rbeta(iter, 5075.986, 313019.131),
        year3 = rbeta(iter, 1, 10000),
        year4 = rbeta(iter, 563.999, 317531.351),
        year5 = rbeta(iter, 563.999, 317531.351)
      ),
      HA_cementless = list(
        year1 = rbeta(iter, 26824.961, 828798.786),
        year2 = rbeta(iter, 12949.986, 842674.122),
        year3 = rbeta(iter, 4624.989, 850997.990),
        year4 = rbeta(iter, 1849.996, 853773.155),
        year5 = rbeta(iter, 3699.993, 851923.428)
      ),
      THA_cemented = list(
        year1 = rbeta(iter, 273.985, 18494.012),
        year2 = rbeta(iter, 273.985, 18494.012),
        year3 = rbeta(iter, 1, 10000),
        year4 = rbeta(iter, 1, 10000),
        year5 = rbeta(iter, 1, 10000)
      ),
      THA_cementless = list(
        year1 = rbeta(iter, 23634.966, 640589.075),
        year2 = rbeta(iter, 5704.987, 658518.522),
        year3 = rbeta(iter, 4074.996, 660149.290),
        year4 = rbeta(iter, 10, 10000),
        year5 = rbeta(iter, 815.001, 663410.394)
      )
    ),
    age_75 = list(
      HA_cemented = list(
        year1 = rbeta(iter, 32736.016, 2181409.054),
        year2 = rbeta(iter, 11904.015, 2202242.765),
        year3 = rbeta(iter, 5952.012, 2208196.343),
        year4 = rbeta(iter, 4463.994, 2209677.158),
        year5 = rbeta(iter, 1488.008, 2212667.252)
      ),
      HA_cementless = list(
        year1 = rbeta(iter, 88512.044, 3311825.646),
        year2 = rbeta(iter, 40568.048, 3359771.930),
        year3 = rbeta(iter, 31347.977, 3368985.589),
        year4 = rbeta(iter, 5532.023, 3394818.027),
        year5 = rbeta(iter, 1843.992, 3398477.039)
      ),
      THA_cemented = list(
        year1 = rbeta(iter, 337.988, 28222.012),
        year2 = rbeta(iter, 168.994, 28391.005),
        year3 = rbeta(iter, 10, 10000),
        year4 = rbeta(iter, 10, 10000),
        year5 = rbeta(iter, 10, 10000)
      ),
      THA_cementless = list(
        year1 = rbeta(iter, 12330.968, 408868.938),
        year2 = rbeta(iter, 2595.996, 418604.316),
        year3 = rbeta(iter, 648.999, 420551.455),
        year4 = rbeta(iter, 10, 10000),
        year5 = rbeta(iter, 10, 10000)
      )
    ),
    age_85 = list(
      HA_cemented = list(
        year1 = rbeta(iter, 88725.094, 5086905.419),
        year2 = rbeta(iter, 15924.979, 5159693.058),
        year3 = rbeta(iter, 6825.013, 5168809.894),
        year4 = rbeta(iter, 10, 10000),
        year5 = rbeta(iter, 10, 10000)
      ),
      HA_cementless = list(
        year1 = rbeta(iter, 103550.019, 4185491.760),
        year2 = rbeta(iter, 33135.915, 4255894.038),
        year3 = rbeta(iter, 20709.969, 4268324.681),
        year4 = rbeta(iter, 8284.001, 4280757.565),
        year5 = rbeta(iter, 2070.996, 4286961.931)
      ),
      THA_cemented = list(
        year1 = rbeta(iter, 130.992, 17029.006),
        year2 = rbeta(iter, 10, 10000),
        year3 = rbeta(iter, 10, 10000),
        year4 = rbeta(iter, 10, 10000),
        year5 = rbeta(iter, 10, 10000)
      ),
      THA_cementless = list(
        year1 = rbeta(iter, 10, 10000),
        year2 = rbeta(iter, 254.996, 64768.979),
        year3 = rbeta(iter, 509.992, 64514.013),
        year4 = rbeta(iter, 10, 10000),
        year5 = rbeta(iter, 10, 10000)
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
  # Assume revision leads to THA
  cost_revision = list(
    revision_generic = list(
      year1 = generic$cost_revision,
      year2 = generic$cost_revision / (1 + discount),
      year3 = generic$cost_revision / (1 + discount)^2,
      year4 = generic$cost_revision / (1 + discount)^3,
      year5 = generic$cost_revision / (1 + discount)^4
    ),
    HA_cemented = list(
      year1 = (generic$cost_revision_HA +
        generic$cost_cementing +
        generic$cost_HA_prosthesis),
      year2 = (generic$cost_revision_HA +
        generic$cost_cementing +
        generic$cost_HA_prosthesis) / (1 + discount),
      year3 = (generic$cost_revision_HA +
        generic$cost_cementing +
        generic$cost_HA_prosthesis) / (1 + discount)^2,
      year4 = (generic$cost_revision_HA +
        generic$cost_cementing +
        generic$cost_HA_prosthesis) / (1 + discount)^3,
      year5 = (generic$cost_revision_HA +
        generic$cost_cementing +
        generic$cost_HA_prosthesis) / (1 + discount)^4
    ),
    HA_cementless = list(
      year1 = (generic$cost_revision_HA +
        generic$cost_cementless +
        generic$cost_HA_prosthesis),
      year2 = (generic$cost_revision_HA +
        generic$cost_cementless +
        generic$cost_HA_prosthesis) / (1 + discount),
      year3 = (generic$cost_revision_HA +
        generic$cost_cementless +
        generic$cost_HA_prosthesis) / (1 + discount)^2,
      year4 = (generic$cost_revision_HA +
        generic$cost_cementless +
        generic$cost_HA_prosthesis) / (1 + discount)^3,
      year5 = (generic$cost_revision_HA +
        generic$cost_cementless +
        generic$cost_HA_prosthesis) / (1 + discount)^4
    ),
    THA_cemented = list(
      year1 = (generic$cost_revision_THA +
        generic$cost_cementing +
        generic$cost_THA_prosthesis$cemented),
      year2 = (generic$cost_revision_THA +
        generic$cost_cementing +
        generic$cost_THA_prosthesis$cemented) / (1 + discount),
      year3 = (generic$cost_revision_THA +
        generic$cost_cementing +
        generic$cost_THA_prosthesis$cemented) / (1 + discount)^2,
      year4 = (generic$cost_revision_THA +
        generic$cost_cementing +
        generic$cost_THA_prosthesis$cemented) / (1 + discount)^3,
      year5 = (generic$cost_revision_THA +
        generic$cost_cementing +
        generic$cost_THA_prosthesis$cemented) / (1 + discount)^4
    ),
    THA_cementless = list(
      year1 = (generic$cost_revision_THA +
        generic$cost_cementless +
        generic$cost_THA_prosthesis$cementless),
      year2 = (generic$cost_revision_THA +
        generic$cost_cementless +
        generic$cost_THA_prosthesis$cementless) / (1 + discount),
      year3 = (generic$cost_revision_THA +
        generic$cost_cementless +
        generic$cost_THA_prosthesis$cementless) / (1 + discount)^2,
      year4 = (generic$cost_revision_THA +
        generic$cost_cementless +
        generic$cost_THA_prosthesis$cementless) / (1 + discount)^3,
      year5 = (generic$cost_revision_THA +
        generic$cost_cementless +
        generic$cost_THA_prosthesis$cementless) / (1 + discount)^4
    )
  )
)
