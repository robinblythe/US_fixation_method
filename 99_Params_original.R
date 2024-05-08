#Enter parameters for original study
prevalence <- list(
  HA_cemented = 384+292,
  HA_cementless = 20+45,
  THA_cemented = 718,
  THA_cementless = 335
)

transitions <- list(
  
  death = list(
    year1 = function() rbeta(1, 19212, 59525),
    year2 = function() rbeta(1, 18798, 35532),
    year3 = function() rbeta(1, 25669, 33340),
    year4 = function() rbeta(1, 30885, 29085),
    year5 = function() rbeta(1, 136399, 96761)
  ),
  
  dislocation = list(
    HA_cemented = list(
      year1 = function() rbeta(1, 2, 67),
      year2 = function() rbeta(1, 2, 67) + 0.005,
      year3 = function() rbeta(1, 2, 67) + 0.010,
      year4 = function() rbeta(1, 2, 67) + 0.015,
      year5 = function() rbeta(1, 2, 67) + 0.02
    ),
    HA_cementless = list(
      year1 = function() rbeta(1, 24, 280),
      year2 = function() rbeta(1, 24, 280) + 0.005,
      year3 = function() rbeta(1, 24, 280) + 0.010,
      year4 = function() rbeta(1, 24, 280) + 0.015,
      year5 = function() rbeta(1, 24, 280) + 0.02
    ),
    THA_cemented = list(
      year1 = function() rbeta(1, 32, 1257),
      year2 = function() rbeta(1, 32, 1257) + 0.005,
      year3 = function() rbeta(1, 32, 1257) + 0.010,
      year4 = function() rbeta(1, 32, 1257) + 0.015,
      year5 = function() rbeta(1, 32, 1257) + 0.02
    ),
    THA_cementless = list(
      year1 = function() rbeta(1, 15, 328),
      year2 = function() rbeta(1, 15, 328) + 0.005,
      year3 = function() rbeta(1, 15, 328) + 0.010,
      year4 = function() rbeta(1, 15, 328) + 0.015,
      year5 = function() rbeta(1, 15, 328) + 0.02
      )
    ),
  
  revision = list(
    
  )
  
)
