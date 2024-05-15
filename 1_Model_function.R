# Simulator can take:
## agegroups c(age_65, age_75, or age_85) and 
## modelgroup c("HA_cemented", "HA_cementless", "THA_cemented", "THA_cementless)

simulator <- function(n, agegroup, modelgroup){
  
  #Year 1
  df <- tibble(
    Surgery = rep(n, iter),
    Cost_surgery = n * costs[[modelgroup]],
    Dislocation_year1 = ceiling(n * transitions$dislocation[[modelgroup]]$year1),
    Revision_year1 = ceiling(n * transitions$revision[[agegroup]][[modelgroup]]$year1),
    Death_year1 = ceiling(n * transitions$death[[agegroup]]$year1)
  ) |>
    mutate(Stable_year1 = n - Dislocation_year1 - Revision_year1 - Death_year1) |>
    mutate(Costs_year1 = 
             Cost_surgery +
             Dislocation_year1 * costs$cost_dislocation$year1 +
             Revision_year1 * costs$cost_revision$year1,
           QALYs_year1 =
             Stable_year1 * utilities[[modelgroup]]$year1 +
             Dislocation_year1 * utilities$dislocation$year1 +
             Revision_year1 * utilities$revision$year1)
  
  #NOTE: CURRENTLY REVISION AND DEATH RATES ARE CUMULATIVE - THIS SHOULD BE ANNUAL MOST LIKELY
  #If cumulative, replace Stable_year(x) with n
  #If annual, use stable_year(x)
  
  #Year 2
  df <- df |>
    mutate(Dislocation_year2 = ceiling(Stable_year1 * transitions$dislocation[[modelgroup]]$year2),
           Revision_year2 = ceiling(Stable_year1 * transitions$revision[[agegroup]][[modelgroup]]$year2),
           Death_year2 = ceiling(Stable_year1 * transitions$death[[agegroup]]$year2)) |>
    mutate(Stable_year2 = Stable_year1 + Dislocation_year1 + Revision_year1 - Dislocation_year2 - Revision_year2 - Death_year2) |>
    mutate(Costs_year2 = 
             Costs_year1 +
             Dislocation_year2 * costs$cost_dislocation$year2 +
             Revision_year2 * costs$cost_revision$year2,
           QALYs_year2 = 
             QALYs_year1 +
             Stable_year2 * utilities[[modelgroup]]$year2 + 
             Dislocation_year2 * utilities$dislocation$year2 +
             Revision_year2 * utilities$revision$year2)
  
  #Year 3
  df <- df |>
    mutate(Dislocation_year3 = ceiling(Stable_year2 * transitions$dislocation[[modelgroup]]$year3),
           Revision_year3 = ceiling(Stable_year2 * transitions$revision[[agegroup]][[modelgroup]]$year3),
           Death_year3 = ceiling(Stable_year2 * transitions$death[[agegroup]]$year3)) |>
    mutate(Stable_year3 = Stable_year2 + Dislocation_year2 + Revision_year2 - Dislocation_year3 - Revision_year3 - Death_year3) |>
    mutate(Costs_year3 = 
             Costs_year2 +
             Dislocation_year3 * costs$cost_dislocation$year3 +
             Revision_year3 * costs$cost_revision$year3,
           QALYs_year3 = 
             QALYs_year2 +
             Stable_year3 * utilities[[modelgroup]]$year3 + 
             Dislocation_year3 * utilities$dislocation$year3 +
             Revision_year3 * utilities$revision$year3)
  
  #Year 4
  df <- df |>
    mutate(Dislocation_year4 = ceiling(Stable_year3 * transitions$dislocation[[modelgroup]]$year4),
           Revision_year4 = ceiling(Stable_year3 * transitions$revision[[agegroup]][[modelgroup]]$year4),
           Death_year4 = ceiling(Stable_year3 * transitions$death[[agegroup]]$year4)) |>
    mutate(Stable_year4 = Stable_year3 + Dislocation_year3 + Revision_year3 - Dislocation_year4 - Revision_year4 - Death_year4) |>
    mutate(Costs_year4 = 
             Costs_year3 +
             Dislocation_year4 * costs$cost_dislocation$year4 +
             Revision_year4 * costs$cost_revision$year4,
           QALYs_year4 = 
             QALYs_year3 +
             Stable_year4 * utilities[[modelgroup]]$year4 + 
             Dislocation_year4 * utilities$dislocation$year4 +
             Revision_year4 * utilities$revision$year4)
  
  #Year 5
  df <- df |>
    mutate(Dislocation_year5 = ceiling(Stable_year4 * transitions$dislocation[[modelgroup]]$year5),
           Revision_year5 = ceiling(Stable_year4 * transitions$revision[[agegroup]][[modelgroup]]$year5),
           Death_year5 = ceiling(Stable_year4 * transitions$death[[agegroup]]$year5)) |>
    mutate(Stable_year5 = Stable_year4 + Dislocation_year4 + Revision_year4 - Dislocation_year5 - Revision_year5 - Death_year5) |>
    mutate(Costs_year5 = 
             Costs_year4 +
             Dislocation_year5 * costs$cost_dislocation$year5 +
             Revision_year5 * costs$cost_revision$year5,
           QALYs_year5 = 
             QALYs_year4 +
             Stable_year5 * utilities[[modelgroup]]$year5 + 
             Dislocation_year5 * utilities$dislocation$year5 +
             Revision_year5 * utilities$revision$year5)
  
}



