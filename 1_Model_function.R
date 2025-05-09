# Simulator can take:
## agegroups c(age_65, age_75, or age_85) and
## modelgroup c("HA_cemented", "HA_cementless", "THA_cemented", "THA_cementless)

simulator <- function(n, agegroup, modelgroup) {
  # First create a function that iterates over years for 2-5 to simplify code
  # Use integers for year, prev_year (e.g. 3, 2)
  # Inner function goes within simulator to allow it to use the same arguments as simulator
  year_function <- function(df, year, prev_year) {
    df |>
      mutate(
        # Dislocation rate = Stable from last year * dislocation rate current year
        Dislocation = get(paste0("Stable_year", prev_year)) *
          transitions$dislocation[[modelgroup]][[paste0("year", year)]],
        # Revision rate = Stable from last year * revision rate current year
        Revision = get(paste0("Stable_year", prev_year)) *
          transitions$revision[[agegroup]][[modelgroup]][[paste0("year", year)]],
        # Mortality rate = Stable + revisions + dislocations from last year * mortality rate current year
        Death = (get(paste0("Stable_year", prev_year)) +
          get(paste0("Dislocation_year", prev_year)) +
          get(paste0("Revision_year", prev_year)) *
          transitions$death[[agegroup]][[paste0("year", year)]])
      ) |>
      mutate(
        # Stable = sum of last year's stable, dislocations, and revisions,
        # MINUS this year's dislocations, revisions, and deaths
        Stable = get(paste0("Stable_year", prev_year)) +
          get(paste0("Dislocation_year", prev_year)) +
          get(paste0("Revision_year", prev_year)) -
          Dislocation -
          Revision -
          Death
      ) |>
      mutate(
        # Costs are cumulative
        # Equal to last year's costs plus this year's dislocations and revisions
        Costs =
          get(paste0("Costs_year", prev_year)) +
            Dislocation * costs$cost_dislocation[[paste0("year", year)]] +
            Revision * costs$cost_revision$revision_generic[[paste0("year", year)]],

        # QALYs are cumulative
        # Equal to last year's QALYs plus this year's stable, dislocations, and revisions
        QALYs =
          get(paste0("QALYs_year", prev_year)) +
            Stable * utilities[[modelgroup]][[paste0("year", year)]] +
            Dislocation * utilities$dislocation[[paste0("year", year)]] +
            Revision * utilities$revision[[paste0("year", year)]]
      )
  }

  # Year 1 - set up dataframe
  df <- tibble(
    # Surgery = number of patients entering model
    Surgery = rep(n, iter),
    # Starting costs of surgery
    Cost_surgery = n * costs[[modelgroup]],
    # End of year 1: multiply by probabilities of dislocation, revision, and death
    Dislocation_year1 = n * transitions$dislocation[[modelgroup]]$year1,
    Revision_year1 = n * transitions$revision[[agegroup]][[modelgroup]]$year1,
    Death_year1 = n * transitions$death[[agegroup]]$year1
  ) |>
    mutate(
      # Stable at the end of year 1 = surgeries minus dislocations, revisions, and deaths
      Stable_year1 = n - Dislocation_year1 - Revision_year1 - Death_year1
    ) |>
    mutate(
      # Costs at the end of year 1 = cost of surgery + costs of dislocations and revisions
      Costs_year1 =
        Cost_surgery +
          Dislocation_year1 * costs$cost_dislocation$year1 +
          Revision_year1 * costs$cost_revision$revision_generic$year1,

      # QALYs at the end of year 1 = QALYs from stable state, dislocations, and revisions (no QALY for death)
      QALYs_year1 =
        Stable_year1 * utilities[[modelgroup]]$year1 +
          Dislocation_year1 * utilities$dislocation$year1 +
          Revision_year1 * utilities$revision$year1
    )

  # Year 2
  df <- year_function(df, 2, 1) |>
    rename(
      Dislocation_year2 = Dislocation,
      Revision_year2 = Revision,
      Death_year2 = Death,
      Stable_year2 = Stable,
      Costs_year2 = Costs,
      QALYs_year2 = QALYs
    )

  df <- year_function(df, 3, 2) |>
    rename(
      Dislocation_year3 = Dislocation,
      Revision_year3 = Revision,
      Death_year3 = Death,
      Stable_year3 = Stable,
      Costs_year3 = Costs,
      QALYs_year3 = QALYs
    )

  df <- year_function(df, 4, 3) |>
    rename(
      Dislocation_year4 = Dislocation,
      Revision_year4 = Revision,
      Death_year4 = Death,
      Stable_year4 = Stable,
      Costs_year4 = Costs,
      QALYs_year4 = QALYs
    )

  df <- year_function(df, 5, 4) |>
    rename(
      Dislocation_year5 = Dislocation,
      Revision_year5 = Revision,
      Death_year5 = Death,
      Stable_year5 = Stable,
      Costs_year5 = Costs,
      QALYs_year5 = QALYs
    )
}

# Function for getting costs, QALYs from each simulator
# Takes agegroup (65, 75, 85), arthroplasty (HA, THA), fixation (cemented, cementless)
modeller <- function(agegroup, arthroplasty, fixation) {
  tibble(
    Costs =
      get(paste(fixation, agegroup, sep = "_"))[[arthroplasty]]$Costs_year5 - # Take policy type
        (get(paste0("baseline_", agegroup))[[paste0(arthroplasty, "_cemented_", agegroup)]]$Costs_year5 + # subtract (baseline cemented + baseline cementless)
          (get(paste0("baseline_", agegroup))[[paste0(arthroplasty, "_cementless_", agegroup)]]$Costs_year5)),
    QALYs =
      get(paste(fixation, agegroup, sep = "_"))[[arthroplasty]]$QALYs_year5 -
        (get(paste0("baseline_", agegroup))[[paste0(arthroplasty, "_cemented_", agegroup)]]$QALYs_year5 +
          (get(paste0("baseline_", agegroup))[[paste0(arthroplasty, "_cementless_", agegroup)]]$QALYs_year5)),
    Strategy = paste0("All patients receive ", fixation, " fixation"),
    Prosthesis = ifelse(arthroplasty == "HA", "Hemiarthroplasty", "Total hip arthroplasty"),
    Age = ifelse(agegroup == 65, "65 to 74",
      ifelse(agegroup == 75, "75 to 84", "85 and over")
    )
  )
}
