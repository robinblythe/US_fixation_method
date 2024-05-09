#Enter parameters for original study
prevalence <- list(
  HA_cemented = 384+292,
  HA_cementless = 20+45,
  THA_cemented = 718,
  THA_cementless = 335
)

#Weights for original study analysis
HA_weight_cemented <- c(384/676, 292/676)
HA_weight_cementless <- c(20/65, 45/65)

transitions <- list(
  
  death = list(
    age_65 = list(
      year1 = rbeta(iter, 1974, 16301),
      year2 = rbeta(iter, 2731, 14336),
      year3 = rbeta(iter, 3626, 13890),
      year4 = rbeta(iter, 3650, 11009),
      year5 = rbeta(iter, 4011, 9964)
      ),
    age_75 = list(
      year1 = rbeta(iter, 5943, 28408),
      year2 = rbeta(iter, 7586, 21827),
      year3 = rbeta(iter, 9689, 18808),
      year4 = rbeta(iter, 10884, 15092),
      year5 = rbeta(iter, 11133, 11588)
      ),
    age_85 = list(
      year1 = rbeta(iter, 6617, 15662),
      year2 = rbeta(iter, 9359, 12818),
      year3 = rbeta(iter, 10417, 9091),
      year4 = rbeta(iter, 11543, 6606),
      year5 = rbeta(iter, 11322, 4273)
      )
    ),
  
  dislocation = list(
    HA_cemented = list(
      year1 = rbeta(iter, 2, 67),
      year2 = rbeta(iter, 2, 67) + 0.005,
      year3 = rbeta(iter, 2, 67) + 0.010,
      year4 = rbeta(iter, 2, 67) + 0.015,
      year5 = rbeta(iter, 2, 67) + 0.02
    ),
    HA_cementless = list(
      year1 = rbeta(iter, 24, 280),
      year2 = rbeta(iter, 24, 280) + 0.005,
      year3 = rbeta(iter, 24, 280) + 0.010,
      year4 = rbeta(iter, 24, 280) + 0.015,
      year5 = rbeta(iter, 24, 280) + 0.02
    ),
    THA_cemented = list(
      year1 = rbeta(iter, 32, 1257),
      year2 = rbeta(iter, 32, 1257) + 0.005,
      year3 = rbeta(iter, 32, 1257) + 0.010,
      year4 = rbeta(iter, 32, 1257) + 0.015,
      year5 = rbeta(iter, 32, 1257) + 0.02
    ),
    THA_cementless = list(
      year1 = rbeta(iter, 15, 328),
      year2 = rbeta(iter, 15, 328) + 0.005,
      year3 = rbeta(iter, 15, 328) + 0.010,
      year4 = rbeta(iter, 15, 328) + 0.015,
      year5 = rbeta(iter, 15, 328) + 0.02
      )
    ),
  
  revision = list(
    age_65 = list(
      HA_cemented = list( #Defined as unipolar[1] bipolar[2]
        year1 = rbeta(iter, 101, 3789)*HA_weight_cemented[1] + rbeta(iter, 76, 2727)*HA_weight_cemented[2],
        year2 = rbeta(iter, 30, 1752)*HA_weight_cemented[1] + rbeta(iter, 17, 985)*HA_weight_cemented[2],
        year3 = rbeta(iter, 19, 1120)*HA_weight_cemented[1] + rbeta(iter, 5, 464)*HA_weight_cemented[2],
        year4 = rbeta(iter, 14, 738)*HA_weight_cemented[1] + rbeta(iter, 1, 168)*HA_weight_cemented[2],
        year5 = rbeta(iter, 6, 449)*HA_weight_cemented[1] + rbeta(iter, 3, 307)*HA_weight_cemented[2],
      ),
      HA_cementless = list(
        year1 = rbeta(iter, 33, 892)*HA_weight_cemented[1] + rbeta(iter, 29, 615)*HA_weight_cemented[2],
        year2 = rbeta(iter, 10, 369)*HA_weight_cemented[1] + rbeta(iter, 76, 2727)*HA_weight_cemented[2],
        year3 = rbeta(iter, 4, 204)*HA_weight_cemented[1] + rbeta(iter, 0, 31)*HA_weight_cemented[2],
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
