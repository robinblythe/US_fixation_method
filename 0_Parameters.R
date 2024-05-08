#Enter parameters for original study
prevalence <- list(
  HA_cemented = 384+292,
  HA_cementless = 20+45,
  THA_cemented = 718,
  THA_cementless = 335
)

transitions <- list(
  
  death = list(
    age_65 = list(
      year1 = function() rbeta(1, 1974, 16301),
      year2 = function() rbeta(1, 2731, 14336),
      year3 = function() rbeta(1, 3626, 13890),
      year4 = function() rbeta(1, 3650, 11009),
      year5 = function() rbeta(1, 4011, 9964)
      ),
    age_75 = list(
      year1 = function() rbeta(1, 5943, 28408),
      year2 = function() rbeta(1, 7586, 21827),
      year3 = function() rbeta(1, 9689, 18808),
      year4 = function() rbeta(1, 10884, 15092),
      year5 = function() rbeta(1, 11133, 11588)
      ),
    age_85 = list(
      year1 = function() rbeta(1, 6617, 15662),
      year2 = function() rbeta(1, 9359, 12818),
      year3 = function() rbeta(1, 10417, 9091),
      year4 = function() rbeta(1, 11543, 6606),
      year5 = function() rbeta(1, 11322, 4273)
      )
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
    age_65 = list(
      HA_cemented = list(
        year1 = function() 1,
        year2 = function() 1,
        year3 = function() 1,
        year4 = function() 1,
        year5 = function() 1
      ),
      HA_cementless = list(
        year1 = function() 1,
        year2 = function() 1,
        year3 = function() 1,
        year4 = function() 1,
        year5 = function() 1
      ),
      THA_cemented = list(
        year1 = function() 1,
        year2 = function() 1,
        year3 = function() 1,
        year4 = function() 1,
        year5 = function() 1
      ),
      THA_cementless = list(
        year1 = function() 1,
        year2 = function() 1,
        year3 = function() 1,
        year4 = function() 1,
        year5 = function() 1
      )
      ),
    
    age_75 = list(
      HA_cemented = list(
        year1 = function() 1,
        year2 = function() 1,
        year3 = function() 1,
        year4 = function() 1,
        year5 = function() 1
      ),
      HA_cementless = list(
        year1 = function() 1,
        year2 = function() 1,
        year3 = function() 1,
        year4 = function() 1,
        year5 = function() 1
      ),
      THA_cemented = list(
        year1 = function() 1,
        year2 = function() 1,
        year3 = function() 1,
        year4 = function() 1,
        year5 = function() 1
      ),
      THA_cementless = list(
        year1 = function() 1,
        year2 = function() 1,
        year3 = function() 1,
        year4 = function() 1,
        year5 = function() 1
      )
    ),
    
    age_85 = list(
      HA_cemented = list(
        year1 = function() 1,
        year2 = function() 1,
        year3 = function() 1,
        year4 = function() 1,
        year5 = function() 1
      ),
      HA_cementless = list(
        year1 = function() 1,
        year2 = function() 1,
        year3 = function() 1,
        year4 = function() 1,
        year5 = function() 1
      ),
      THA_cemented = list(
        year1 = function() 1,
        year2 = function() 1,
        year3 = function() 1,
        year4 = function() 1,
        year5 = function() 1
      ),
      THA_cementless = list(
        year1 = function() 1,
        year2 = function() 1,
        year3 = function() 1,
        year4 = function() 1,
        year5 = function() 1
      )
    )
  )
)

utilities <- list()

costs <- list()
