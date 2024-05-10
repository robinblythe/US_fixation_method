#Enter parameters for original study
prevalence <- list( #unipolar + bipolar
  age_65 = list(
    HA_cemented = 384+292,
    HA_cementless = 20+45,
    THA_cemented = 718,
    THA_cementless = 335),
  
  age_75 = list(
    HA_cemented = 1142+685,
    HA_cementless = 64+115,
    THA_cemented = 491,
    THA_cementless = 177
  ),
  
  age_85 = list(
    HA_cemented = 1598+761,
    HA_cementless = 83+121,
    THA_cemented = 163,
    THA_cementless = 64
  )
)

#Weights for original study analysis - can discard when new data arrives
weights <- list(
  age_65 = list(
    cemented = c(384/676, 292/676),
    cementless = c(20/65, 45/65)
  ),
  age_75 = list(
    cemented = c(1142/1827, 685/1827),
    cementless = c(64/179, 115/179)
  ),
  age_85 = list(
    cemented = c(1598/2359, 761/2359),
    cementless = c(83/204, 121/204)
  )
)

#Note that Beta is bounded (0,1)
#For values at or near 0, use an approximation: Beta(0, 100)
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
      HA_cemented = list( #Defined as unipolar[1] + bipolar[2]
        year1 = rbeta(iter, 101, 3789)*weights$age_65$cemented[1] + rbeta(iter, 76, 2727)*weights$age_65$cemented[2],
        year2 = rbeta(iter, 30, 1752)*weights$age_65$cemented[1] + rbeta(iter, 17, 985)*weights$age_65$cemented[2],
        year3 = rbeta(iter, 19, 1121)*weights$age_65$cemented[1] + rbeta(iter, 5, 464)*weights$age_65$cemented[2],
        year4 = rbeta(iter, 14, 738)*weights$age_65$cemented[1] + rbeta(iter, 1, 168)*weights$age_65$cemented[2],
        year5 = rbeta(iter, 5, 449)*weights$age_65$cemented[1] + rbeta(iter, 3, 307)*weights$age_65$cemented[2]
      ),
      HA_cementless = list(
        year1 = rbeta(iter, 33, 892)*weights$age_65$cementless[1] + rbeta(iter, 29, 615)*weights$age_65$cementless[2],
        year2 = rbeta(iter, 10, 369)*weights$age_65$cementless[1] + rbeta(iter, 2, 149)*weights$age_65$cementless[2],
        year3 = rbeta(iter, 4, 204)*weights$age_65$cementless[1] + rbeta(iter, 0, 31)*weights$age_65$cementless[2],
        year4 = rbeta(iter, 1, 88)*weights$age_65$cementless[1] + rbeta(iter, 0, 47)*weights$age_65$cementless[2],
        year5 = rbeta(iter, 1, 88)*weights$age_65$cementless[1] + rbeta(iter, 0, 100)*weights$age_65$cementless[2]
      ),
      THA_cemented = list(
        year1 = rbeta(iter, 101, 3789),
        year2 = rbeta(iter, 9, 942),
        year3 = rbeta(iter, 4, 632),
        year4 = rbeta(iter, 1, 310),
        year5 = rbeta(iter, 3, 366)
      ),
      THA_cementless = list(
        year1 = rbeta(iter, 120, 3119),
        year2 = rbeta(iter, 6, 587),
        year3 = rbeta(iter, 5, 464),
        year4 = rbeta(iter, 1, 210),
        year5 = rbeta(iter, 1, 210)
      )
      ),
    
    age_75 = list(
      HA_cemented = list(
        year1 = rbeta(iter, 218, 11238)*weights$age_75$cemented[1] + rbeta(iter, 135, 6311)*weights$age_75$cemented[2],
        year2 = rbeta(iter, 21, 2945)*weights$age_75$cemented[1] + rbeta(iter, 9, 1308)*weights$age_75$cemented[2],
        year3 = rbeta(iter, 8, 1151)*weights$age_75$cemented[1] + rbeta(iter, 3, 752)*weights$age_75$cemented[2],
        year4 = rbeta(iter, 6, 1188)*weights$age_75$cemented[1] + rbeta(iter, 1, 457)*weights$age_75$cemented[2],
        year5 = rbeta(iter, 6, 1188)*weights$age_75$cemented[1] + rbeta(iter, 1, 252)*weights$age_75$cemented[2]
      ),
      HA_cementless = list(
        year1 = rbeta(iter, 83, 2418)*weights$age_75$cementless[1] + rbeta(iter, 42, 1275)*weights$age_75$cementless[2],
        year2 = rbeta(iter, 6, 587)*weights$age_75$cementless[1] + rbeta(iter, 3, 310)*weights$age_75$cementless[2],
        year3 = rbeta(iter, 3, 372)*weights$age_75$cementless[1] + rbeta(iter, 1, 157)*weights$age_75$cementless[2],
        year4 = rbeta(iter, 2, 264)*weights$age_75$cementless[1] + rbeta(iter, 1, 153)*weights$age_75$cementless[2],
        year5 = rbeta(iter, 2, 256)*weights$age_75$cementless[1] + rbeta(iter, 0, 38)*weights$age_75$cementless[2]
      ),
      THA_cemented = list(
        year1 = rbeta(iter, 87, 2917),
        year2 = rbeta(iter, 4, 627),
        year3 = rbeta(iter, 2, 404),
        year4 = rbeta(iter, 0, 135),
        year5 = rbeta(iter, 1, 237)
      ),
      THA_cementless = list(
        year1 = rbeta(iter, 69, 1707),
        year2 = rbeta(iter, 6, 440),
        year3 = rbeta(iter, 0, 34),
        year4 = rbeta(iter, 0, 94),
        year5 = rbeta(iter, 1, 183)
      )
    ),
    
    age_85 = list(
      HA_cemented = list(
        year1 = rbeta(iter, 160, 12162)*weights$age_85$cemented[1] + rbeta(iter, 79, 4857)*weights$age_85$cemented[2],
        year2 = rbeta(iter, 2, 1223)*weights$age_85$cemented[1] + rbeta(iter, 1, 624)*weights$age_85$cemented[2],
        year3 = rbeta(iter, 1, 612)*weights$age_85$cemented[1] + rbeta(iter, 5, 752)*weights$age_85$cemented[2],
        year4 = rbeta(iter, 2, 849)*weights$age_85$cemented[1] + rbeta(iter, 0, 126)*weights$age_85$cemented[2],
        year5 = rbeta(iter, 0, 312)*weights$age_85$cemented[1] + rbeta(iter, 0, 100)*weights$age_85$cemented[2]
      ),
      HA_cementless = list(
        year1 = rbeta(iter, 36, 1746)*weights$age_85$cementless[1] + rbeta(iter, 28, 952)*weights$age_85$cementless[2],
        year2 = rbeta(iter, 2, 387)*weights$age_85$cementless[1] + rbeta(iter, 0, 31)*weights$age_85$cementless[2],
        year3 = rbeta(iter, 0, 135)*weights$age_85$cementless[1] + rbeta(iter, 2, 178)*weights$age_85$cementless[2],
        year4 = rbeta(iter, 0, 100)*weights$age_85$cementless[1] + rbeta(iter, 1, 109)*weights$age_85$cementless[2],
        year5 = rbeta(iter, 1, 168)*weights$age_85$cementless[1] + rbeta(iter, 0, 44)*weights$age_85$cementless[2]
      ),
      THA_cemented = list(
        year1 = rbeta(iter, 35, 1006),
        year2 = rbeta(iter, 1, 183),
        year3 = rbeta(iter, 1, 153),
        year4 = rbeta(iter, 2, 142),
        year5 = rbeta(iter, 0, 66)
      ),
      THA_cementless = list(
        year1 = rbeta(iter, 33, 572),
        year2 = rbeta(iter, 0, 100),
        year3 = rbeta(iter, 0, 55),
        year4 = rbeta(iter, 0, 53),
        year5 = rbeta(iter, 0, 100)
      )
    )
  )
)

#Dislocation should only be assumed to contribute to QALY equivalent to wait times.
utilities <- list(
  
  dislocation = list(
    year1 = rbeta(iter, 9.77, 15.95),
    year2 = rbeta(iter, 9.77, 15.95)/1+discount,
    year3 = rbeta(iter, 9.77, 15.95)/(1+discount)^2,
    year4 = rbeta(iter, 9.77, 15.95)/(1+discount)^3,
    year5 = rbeta(iter, 9.77, 15.95)/(1+discount)^4
  ),
  
  revision = list(
    year1 = rbeta(iter, 36.94, 68.59),
    year2 = rbeta(iter, 36.94, 68.59)/1+discount,
    year3 = rbeta(iter, 36.94, 68.59)/(1+discount)^2,
    year4 = rbeta(iter, 36.94, 68.59)/(1+discount)^3,
    year5 = rbeta(iter, 36.94, 68.59)/(1+discount)^4
  ),
  
  HA_cemented = list(
    year1 = rbeta(iter, 95.3001, 63.5334),
    year2 = rbeta(iter, 97.97326, 50.47107)/(1+discount),
    year3 = rbeta(iter, 97.97326, 50.47107)/(1+discount)^2,
    year4 = rbeta(iter, 97.97326, 50.47107)/(1+discount)^3,
    year5 = rbeta(iter, 97.97326, 50.47107)/(1+discount)^4
  ),
  
  HA_cementless = list(
    year1 = rbeta(iter, 8.044704, 6.852896),
    year2 = rbeta(iter, 48.65102, 35.23005)/(1+discount),
    year3 = rbeta(iter, 48.65102, 35.23005)/(1+discount)^2,
    year4 = rbeta(iter, 48.65102, 35.23005)/(1+discount)^3,
    year5 = rbeta(iter, 48.65102, 35.23005)/(1+discount)^4
  ),
  
  THA_cemented = list(
    year1 = rbeta(iter, 5575.439, 2168.226),
    year2 = rbeta(iter, 5468.776, 1921.462)/(1+discount),
    year3 = rbeta(iter, 5468.776, 1921.462)/(1+discount)^2,
    year4 = rbeta(iter, 5468.776, 1921.462)/(1+discount)^3,
    year5 = rbeta(iter, 5468.776, 1921.462)/(1+discount)^4
  ),
  
  THA_cementless = list(
    year1 = rbeta(iter, 5615.287, 2293.568),
    year2 = rbeta(iter, 5526.679, 2044.114)/(1+discount),
    year3 = rbeta(iter, 5526.679, 2044.114)/(1+discount)^2,
    year4 = rbeta(iter, 5526.679, 2044.114)/(1+discount)^3,
    year5 = rbeta(iter, 5526.679, 2044.114)/(1+discount)^4
  )
)

costs <- list()
