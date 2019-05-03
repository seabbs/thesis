/**
 * Baseline TB and BCG vaccination model
 */
model Baseline {
  
  //Timestep
  const timestep = 1 //timestep (if using)
  // Model dimensions
  const e_bcg = 2 // 0 = unvaccinated, 1 = vaccinated
  const e_age = 12 // 0,..9 = 5 year age groups (i.e 0-4), 10 = 50-69 and 11 = 70-89
  const e_AgeGroup = 3 // Age groups for parameters

  dim bcg(e_bcg)
  dim age(e_age)
  dim age2(e_age)
  dim AgeGroup(e_AgeGroup)
  
  //Age at vaccination
  const vac_scheme = 0 //0 = vaccination at school age, 1 = vaccination at birth, 2 = no vaccination.
  const e_d_of_p = 6 // Duration of protection (must be at least 1)
  
  dim d_of_p(e_d_of_p)

  //Control model
  const const_pop = 0 //Set to 1 for constant population (i.e births == deaths)
  const no_age = 0 //Set to 1 to turn off ageing
  const no_disease = 0 //Set to 1 to prevent disease from being initialised / importation
  const noise_switch = 1 // Set noise to 1 to include process noise, and 0 to exclude.
  const scale_rate_treat = 1 //Scale up rate of starting treatment over time (0 to turn off)
  const non_uk_born_scaling = 1 // Scale up of non-UK born cases (from 1960 to 2000). 1 = linear, 2 = log, 3+ = linear
  const beta_df = 1 //Degrees of freedom for transmission prob. 1 = constant across age groups, 2 = modified for children, 3 = modified for children and older adults.
  const mix_type = 1 //Amount of mixing between non UK born and UK born. 1=Homogeneous mixing (0.5 - 1), 2 = hetergeneous mixing (0 - 0.5)ı
  // Time dimensions
  const ScaleTime = 1 / 12 // Scale model over a year 
  //const ScaleTime = 1 // Scale model over a month
  
  // Parameter scales
  const dscale = 12 / 365.25 * ScaleTime 
  const mscale = 1 * ScaleTime
  const yscale = 12 * ScaleTime
  
  //Initialise model
  const init_pop = 37359045 //Estimated intial population - http://www.visionofbritain.org.uk/census/table/EW1931COU1_M3
  const init_P_cases = 49798 // TB cases in England (and Wales)
  const init_E_cases = 16084 // https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/554455/TB_case_notifications_1913_to_2015.pdf

  //Disease model parameters
  
  // Non-UK born mixing
  param M
  // Effective contact rate
  param c_eff
  
  // Historic effective contact rate
  param c_hist
  
  // Half life of historic effective contact rate
  param HistContactHalf
  
  // Average number of contacts (across age groups)
  param TotalAgeContacts[age](has_output = 0, has_input = 0)
  param TotalContacts(has_output = 0, has_input = 0)
    
  // Modifier for transmission probability
  param beta_child_mod
  param beta_older_adult_mod
  
  // Protection from infection due to prior latent infection
  state delta(has_output = 0, has_input = 0) 
  
  // Transition from high risk latent disease to active disease
  state epsilon_h_0_4(has_output = 0, has_input = 0)  //Age specific parameters
  state epsilon_h_5_14(has_output = 0, has_input = 0) 
  state epsilon_h_15_89(has_output = 0, has_input = 0) 

  // Transition to low risk latent disease from high risk latent disease
  state kappa_0_4(has_output = 0, has_input = 0)  //Age specific parameters
  state kappa_5_14(has_output = 0, has_input = 0) 
  state kappa_15_89(has_output = 0, has_input = 0) 

  // Transition from low risk latent disease to active disease
  state epsilon_l_0_4(has_output = 0, has_input = 0)  //Age specific parameters
  state epsilon_l_5_14(has_output = 0, has_input = 0) 
  state epsilon_l_15_89(has_output = 0, has_input = 0) 

  // Rate of succesful treatment completion
  state phi_0_14(has_output = 0, has_input = 0)  //Age specific parameters
  state phi_15_69(has_output = 0, has_input = 0) 
  state phi_70_89(has_output = 0, has_input = 0) 
    
  // Proportion of cases that have pulmonary TB
  state Upsilon_0_14(has_output = 0, has_input = 0)  //Age specific parameters
  state Upsilon_15_69(has_output = 0, has_input = 0) 
  state Upsilon_70_89(has_output = 0, has_input = 0) 

  // Proportion of cases that have pulmonary smear postive TB
  state rho_0_14(has_output = 0, has_input = 0)  //Age specific parameters
  state rho_15_69(has_output = 0, has_input = 0) 
  state rho_70_89(has_output = 0, has_input = 0) 

  // Rate of starting treatment - pulmonary/extra-pulmonary
  // Pulmonary
  state nu_p_0_14(has_output = 0, has_input = 0) //Age specific parameters
  state nu_p_15_89(has_output = 0, has_input = 0)
    
  // Extra-pulmonary
  state nu_e_0_14(has_output = 0, has_input = 0) //Age specific parameters
  state nu_e_15_89(has_output = 0, has_input = 0)
  
  //Rate of treatment scale up
  param TreatScale(has_output = 0, has_input = 0)
    
  // Rate loss to follow up - pulmonary/extra-pulmonary
  state zeta_0_14(has_output = 0, has_input = 0)  //Age specific parameters
  state zeta_15_69(has_output = 0, has_input = 0) 
  state zeta_70_89(has_output = 0, has_input = 0) 

  // Rate of TB mortality
  state mu_t_0_14(has_output = 0, has_input = 0)  //Age specific parameters
  state mu_t_15_69(has_output = 0, has_input = 0) 
  state mu_t_70_89(has_output = 0, has_input = 0) 
    
  //BCG vaccination parameters
  
  // Age specific protection from infection conferred by BCG vaccination
  state chi_init(has_output = 0, has_input = 0) 
  // Protection from active disease due to BCG vaccination
  state alpha_t[d_of_p](has_output = 0, has_input = 0) //Estimation effectiveness of BCG vaccine by age group
  
  //Demographic model parameters
  //Ageing
  param theta[age](has_output = 0, has_input = 0)
  
  //Noise parameters
  noise CSample[age, age2](has_output = 0, has_input = 0) // Sampled contact rate
  noise coverage_sample(has_output = 0, has_input = 0) //Noisy coverage sample

  // Time varying parameter states
  state foi[age](has_output = 0, has_input = 0) // force of infection
  state gamma[age](has_output = 0, has_input = 0) //Coverage of the vaccination program by age
      
  // Average rate of starting treatment   
  state avg_nu_p(has_output = 0, has_input = 0)
  
  //Calculation parameters
  param I_age[age](has_output = 0, has_input = 0)
  param I_bcg[bcg](has_output = 0, has_input = 0)
    
  //Observational parameters
  param MeasError
  param MeasStd
    
  // Time varing parameter states
  //Demographic
  state mu[age](has_output = 0, has_input = 0) //All cause mortality excluding TB
  
  //Average mortality
  state avg_tb_mort(has_output = 0, has_input = 0)
  state avg_mort(has_output = 0, has_input = 0)
    
  //Vaccination
  state age_at_vac(has_output = 0, has_input = 0) //Age at vaccination
  state chi[age](has_output = 0, has_input = 0) //Protection from initial infection due to BCG vaccination
  state alpha[age](has_output = 0, has_input = 0) //Protection from active disease due to BCG vaccination

  //Population states
  state S[bcg, age] // susceptible
  state H[bcg, age] // high risk latent
  state L[bcg, age] // low risk latent
  state P[bcg, age] // pulmonary TB
  state E[bcg, age] // extra-pulmonary TB only
  state T_E[bcg, age] // TB on treatment (extra-pulmonary)
  state T_P[bcg, age] // TB on treatment (pulmonary)
  state N[bcg, age](has_output = 0, has_input = 0) // Overall population
  state NSum(has_input = 0, has_output = 0) // Sum of population 
  state death_sum[age](has_output = 0, has_input = 0) //Used to estimate deaths

  //Accumalator states
  state YearlyPulCases[bcg, age] // yearly pulmonary cases starting treatment
  state YearlyEPulCases[bcg, age] // yearly extra-pulmonary cases starting treatment
  state YearlyDeaths[bcg, age] // TB deaths (yearly)
  
  // Reporting states
  state YearlyPAgeCases[age] 
  state YearlyPCases 
  state YearlyEAgeCases[age]
  state YearlyECases 
    
  state YearlyAgeCases[age]
  state YearlyCases
    
  // States for tracking non UK born in model
  state EstNUKCases[age](has_output = 0, has_input = 0)
    
  //Noise variables
  noise NoiseNUKCases[age](has_output = 0, has_input = 0)
  noise births(has_output = 0, has_input = 0) //Sampled noisy births
  noise mu_all[age](has_output = 0, has_input = 0) // All cause natural mortality
    
  //Input
  input births_input //Births (time varying)
  input pop_dist[age] //Population distribution (average from 2000 to 2015).
  input exp_life_span[age] //Expected life span (time varying)
  input polymod[age, age2] //Polymod contact matrix
  input polymod_sd[age, age2] //Polymod SD contact matrix
  input NonUKBornPCases[age] //Non UK born Pulmonary cases (time varying)
  input NUKCases2000[age] //Non UK born cases in 2000.
    
  //Observations
  obs YearlyHistPInc //Historic yearly incidence (pulmonary)
  obs YearlyInc // Yearly overall incidence
  obs YearlyAgeInc[age] // Yearly incidence by age group
  obs YearlyChildInc //Yearly incidence in children
  obs YearlyAdultInc //Yearly incidence in adults
  obs YearlyOlderAdultInc //Yearly incidence in older adults
  
  sub parameter {
        
        //Disease priors
        M ~ uniform(0, 1)
        c_eff ~ uniform(0, 10)
        c_hist ~ uniform(10, 15)
        
        //Modification of transmission probability by age.
        beta_child_mod ~ truncated_gaussian(mean = 1, std = 0.5, lower = 0)
        beta_older_adult_mod ~ truncated_gaussian(mean = 1, std = 0.5, lower = 0)
        
        //Historic Contact half life
        HistContactHalf ~ uniform(0, 20)
    
        //Rate of treatment scale up
        TreatScale <- 1
    
        //Measurement error
        MeasError ~ truncated_gaussian(mean = 0.9, std = 0.1, lower = 0)
    
        // Prior on measurement Std
        MeasStd ~ truncated_gaussian(mean = 0.05, std = 0.05, lower = 0)
    
        //Calculation parameters
        I_age <- 1
        I_bcg <- 1
        
        //Demographic model parameters
        theta[age=0:(e_age - 3)] <- (no_age == 0 ? 1 / (5 * yscale) : 0)
        theta[age=(e_age - 2):(e_age - 1)] <- (no_age == 0 ? 1 / (20 * yscale) : 0)
        
        //Calculate the total number of contacts
        TotalAgeContacts <- polymod * I_age
        TotalAgeContacts <- inclusive_scan(TotalAgeContacts)
        TotalContacts <- TotalAgeContacts[e_age - 1] / e_age
      }
    
    sub proposal_parameter {
      //Proposal at 5% of prior SD or range
      inline proposal_scaling = 2
      //Disease priors
      M ~ truncated_gaussian(mean = M, std = 0.1 / proposal_scaling, lower = 0, upper = 1)
      c_eff ~ truncated_gaussian(mean = c_eff, std = 0.5 / proposal_scaling, lower = 0, upper = 5)
      c_hist ~ truncated_gaussian(mean = c_hist, std = 0.5 / proposal_scaling, lower = 10, upper = 15)
      
      //Modification of transmission probability by age.
      beta_child_mod ~ truncated_gaussian(mean = beta_child_mod, std = 0.05 / proposal_scaling,  lower = 0)
      beta_older_adult_mod ~  truncated_gaussian(mean = beta_older_adult_mod, std = 0.05 / proposal_scaling,  lower = 0)
      
      //Historic Contact half life
      HistContactHalf ~ truncated_gaussian(mean = HistContactHalf, std = 2 / proposal_scaling, lower = 0, upper = 20)
    
      //Measurement error
      MeasError ~ truncated_gaussian(mean = MeasError, std = 0.01 / proposal_scaling, lower = 0)
      
      // Prior on measurement Std
      MeasStd ~ truncated_gaussian(mean = MeasStd, std = 0.005 / proposal_scaling, lower = 0)
      
    }
  
    sub initial {
      
      //Initial states
      S[0, age] ~  truncated_gaussian(mean = init_pop * pop_dist[age], std = 0.05 * init_pop * pop_dist[age], lower = 0) // susceptible
      S[0, age] <- (noise_switch == 0 ? init_pop * pop_dist[age] :  S[0, age])
      S[1, age] <- 0 // BCG vaccinated susceptibles
      H[0, age] ~ truncated_gaussian(mean = (init_E_cases + init_P_cases) * pop_dist[age], std = 0.05 * (init_E_cases + init_P_cases) * pop_dist[age], lower = 0) // high risk latents 
      H[0, age] <- (no_disease == 0 ? (noise_switch == 0 ? (init_E_cases + init_P_cases) * pop_dist[age]: H[0, age]) : 0) 
      H[1, age] <- 0 // BCG high risk latent
      L[0, age] ~ truncated_gaussian(mean = 9 * (init_E_cases + init_P_cases) * pop_dist[age], std = 0.05 * 9 * (init_E_cases + init_P_cases) * pop_dist[age], lower = 0) // high risk latents 
      L[0, age] <- (no_disease == 0 ? (noise_switch == 0 ? 9 * (init_E_cases + init_P_cases) * pop_dist[age] : L[0, age]) : 0) 
      L[1, age] <- 0 // BCG low risk latent
      P[0, age] ~  truncated_gaussian(mean = init_P_cases * pop_dist[age], std = 0.05 * init_P_cases * pop_dist[age], lower = 0) // inital pulmonary cases
      P[0, age] <- (no_disease == 0 ? (noise_switch == 0 ? init_P_cases * pop_dist[age] : P[0, age]) : 0) 
      P[1, age] <- 0 //BCG vaccinated pulmonary TB
      E[0, age] ~  truncated_gaussian(mean = init_E_cases * pop_dist[age], std = 0.05 * init_E_cases * pop_dist[age], lower = 0) // inital pulmonary cases
      E[0, age] <- (no_disease == 0 ? (noise_switch == 0 ? init_E_cases * pop_dist[age] : E[0, age]) : 0) 
      E[1, age] <- 0 // BCG extra-pulmonary TB only
      T_E[bcg, age] <- 0// TB on treatment (extra-pulmonary)
      T_P[bcg, age] <- 0// TB on treatment (pulmonary)
      
      //Priors samples without updating against data
      // Priors for BCG vaccination
      //Protection from infection at vaccination
      chi_init ~ truncated_gaussian(mean = 0.185, std = 0.0536, lower = 0, upper = 1)
      //Protection from active TB
      alpha_t[0] ~ log_gaussian(mean = -1.86, std = 0.22)
      alpha_t[1] ~ log_gaussian(mean = -1.19, std = 0.24)
      alpha_t[2] ~ log_gaussian(mean = -0.84, std = 0.22)
      alpha_t[3] ~ log_gaussian(mean = -0.84, std = 0.2)
      alpha_t[4] ~ log_gaussian(mean = -0.28, std = 0.19)
      alpha_t[5] ~ log_gaussian(mean = -0.23, std = 0.29)
      alpha_t <- 1 - alpha_t
      
      //Disease priors
      delta ~ truncated_gaussian(mean = 0.78, std = 0.0408, lower = 0, upper = 1)
      
      // Transition from high risk latent to active TB
      epsilon_h_0_4 ~ truncated_gaussian(mean = 0.00695, std =  0.0013, lower = 0)
      epsilon_h_5_14  ~ truncated_gaussian(mean = 0.0028, std =  0.000561, lower = 0)
      epsilon_h_15_89 ~ truncated_gaussian(mean = 0.000335, std =  0.0000893, lower = 0)
      
      epsilon_h_0_4 <-  0.0069 / dscale //epsilon_h_0_4 / dscale
      epsilon_h_5_14 <- 0.0028 / dscale //epsilon_h_5_14 / dscale
      epsilon_h_15_89 <- 0.000335 / dscale //epsilon_h_15_89 / dscale
      
      // Rate of transition from high risk to low risk latents
      kappa_0_4  ~ truncated_gaussian(mean = 0.0133, std =  0.00242, lower = 0)
      kappa_5_14 ~ truncated_gaussian(mean =  0.012, std =  0.00207, lower = 0)
      kappa_15_89 ~ truncated_gaussian(mean = 0.00725, std = 0.00191, lower = 0)
      
      kappa_0_4 <- 0.0133 / dscale //kappa_0_4 / dscale
      kappa_5_14 <- 0.012 /dscale // kappa_5_14 / dscale
      kappa_15_89 <- 0.00725 / dscale //kappa_15_89 / dscale
      
      // Rate of transition for low risk latent to active TB
      epsilon_l_0_4 ~ truncated_gaussian(mean = 0.000008, std = 0.00000408, lower = 0)
      epsilon_l_5_14 ~ truncated_gaussian(mean =  0.00000984, std = 0.00000467, lower = 0)
      epsilon_l_15_89  ~ truncated_gaussian(mean = 0.00000595, std = 0.00000207, lower = 0)
      
      epsilon_l_0_4 <- 0.000008 / dscale //epsilon_l_0_4 / dscale
      epsilon_l_5_14 <-  0.00000984 /dscale //epsilon_l_5_14 / dscale
      epsilon_l_15_89 <- 0.00000595 / dscale //epsilon_l_15_89 / dscale
      
      // Rate of successful treatment
      phi_0_14 ~ truncated_gaussian(mean = yscale * 0.606, std =  yscale * 0.237, lower = 4 / 12)
      phi_15_69 ~ truncated_gaussian(mean = yscale * 0.645	, std =  yscale * 0.290, lower = 4 / 12)
      phi_70_89 ~ truncated_gaussian(mean = yscale * 0.616, std =  yscale * 0.265, lower = 4 / 12)
      
      phi_0_14 <- 1 / yscale * 0.606 //phi_0_14
      phi_15_69 <-  1 / yscale * 0.645 //phi_15_69
      phi_70_89 <- 1 / yscale * 0.616 //phi_70_89
      
      // Rate of starting treatment - pulmonary/extra-pulmonary
      // Pulmonary
      nu_p_0_14  ~ truncated_gaussian(mean = yscale * 0.181, std =  yscale * 0.310, lower = 0)
      nu_p_15_89 ~ truncated_gaussian(mean = yscale * 0.328, std =  yscale * 0.447, lower = 0)
      nu_p_0_14  <- 1 / yscale * 0.181 //nu_p_0_14 
      nu_p_15_89 <- 1 / yscale * 0.328 //nu_p_15_89
      
      // Extra-pulmonary
      nu_e_0_14 ~ truncated_gaussian(mean = yscale * 0.306	, std =  yscale * 0.602, lower = 0)
      nu_e_15_89 ~ truncated_gaussian(mean = yscale * 0.480, std =  yscale * 0.866, lower = 0)
      nu_e_0_14  <- 1 / yscale * 0.306 //nu_e_0_14 
      nu_e_15_89 <- 1 / yscale * 0.480 //nu_e_15_89 
      
      
      // Rate loss to follow up - pulmonary/extra-pulmonary
      // Extra-pulmonary
      zeta_0_14 <- yscale * 0.00976// ~ truncated_gaussian(mean = yscale * 0.00976, std = yscale * 0.0179, lower = 0)
      zeta_15_69 <- yscale * 0.0304//~ truncated_gaussian(mean = yscale * 0.0304, std = yscale * 0.00764, lower = 0)
      zeta_70_89 <- yscale * 0.00614//~ truncated_gaussian(mean = yscale * 0.00614, std = yscale * 0.0159, lower = 0)
      
      // Rate of TB mortality
      mu_t_0_14 <- yscale * 0.00390//~ truncated_gaussian(mean = yscale * 0.00390, std = yscale * 0.0180, lower = 0)
      mu_t_15_69 <- yscale * 0.0226//~ truncated_gaussian(mean = yscale * 0.0226, std = yscale * 0.00787, lower = 0)
      mu_t_70_89 <- yscale * 0.117//~ truncated_gaussian(mean = yscale * 0.117, std = yscale * 0.0165, lower = 0)
      
      // Proportion of TB cases with pulmonary TB
      Upsilon_0_14 <- 0.629// ~ truncated_gaussian(mean = 0.629, std = 0.0101, lower = 0, upper = 1)
      Upsilon_15_69 <- 0.713// ~ truncated_gaussian(mean = 0.713, std = 0.00377, lower = 0, upper = 1)
      Upsilon_70_89 <- 0.748//~ truncated_gaussian(mean = 0.748, std = 0.00718, lower = 0, upper = 1)
      
      // Propotion of pulmonary TB cases that are smear positive
      rho_0_14 <- 0.302 // ~ truncated_gaussian(mean = 0.302, std = 0.0189, lower = 0, upper = 1)
      rho_15_69 <- 0.637 // ~ truncated_gaussian(mean = 0.637, std = 0.00487, lower = 0, upper = 1)
      rho_70_89 <- 0.531// ~ truncated_gaussian(mean = 0.531, std = 0.0107, lower = 0, upper = 1)

    }
    
    sub transition {
      
      // Reset accumalator variables
      inline yr_reset = yscale
      YearlyPulCases[bcg, age] <- (t_now % 1 < yr_reset ? 0 : YearlyPulCases[bcg, age])
      YearlyEPulCases[bcg, age] <- (t_now % 1 < yr_reset ? 0 : YearlyEPulCases[bcg, age])
      YearlyDeaths[bcg, age] <- (t_now % 1 < yr_reset ? 0 : YearlyDeaths[bcg, age])
      
      
      //Apply BCG vaccination to correct populations
      inline policy_change = 74 * yscale // Assume policy switch occurred in 2005
      //Set up age at vaccination
      age_at_vac <- (t_now >= policy_change ? (vac_scheme == 0 ? 3 : (vac_scheme == 1 ? 0 : -1)) : 3)
      
      // Apply linear transform for protection against initial infection
      chi[age] <- (age_at_vac < 0 ? 0 : (age_at_vac > age ? 0 : (age >= (age_at_vac + e_d_of_p) ? 0 : alpha_t[age - age_at_vac] * chi_init / alpha_t[0])))
      //Back calculate protection from latent disease based on initial protection and overall protection
      alpha[age] <- (age_at_vac < 0 ? 0 : (age_at_vac > age ? 0 : (age >= (age_at_vac + e_d_of_p) ? 0 : (alpha_t[age - age_at_vac] - chi[age])/ (1 - chi[age]))))
      
      //Apply coverage of vac program to correct population
      inline coverage_est = 0.8
      coverage_sample ~ truncated_gaussian(mean = coverage_est, std = 0.05, lower = 0, upper = 1)
      
      // Set vaccination to begin in 1953
      inline vac_start = 22 * yscale
      gamma[age] <- (age_at_vac == age ? 
                       (t_now > vac_start ? 
                       (noise_switch == 1 ? coverage_sample : coverage_est) : 0) : 0)
      
      //Set time from active symptoms to treatment - adjust based on modern standards and log distribution
      //Logistic scaled between 0 and 1
      inline treat_start = 21 * yscale //Treatment first becomes available in 1952
      inline modern_treat = 69 * yscale //Treatment reaches modern levels in 2000
      inline scale_infectious_time = (t_now < treat_start ? 0 : 
                                        (t_now >= modern_treat ? 1 : 
                                           (scale_rate_treat == 0 ? 1 :
                                              1 / (1 + exp(-TreatScale * ((t_now - treat_start)
                                                                            - (modern_treat - treat_start) / 2))))))
      
      nu_p_0_14 <- scale_infectious_time * nu_p_0_14
      nu_p_15_89 <- scale_infectious_time * nu_p_15_89
      nu_e_0_14 <-  scale_infectious_time * nu_e_0_14
      nu_e_15_89 <- scale_infectious_time * nu_e_15_89
  
      // Restrict treatment time to a maximum of 20 years
      inline lowest_time_to_treat = 20
      nu_p_0_14 <- (nu_p_0_14 <  1 / lowest_time_to_treat ? 1 / lowest_time_to_treat :  nu_p_0_14) 
      nu_p_15_89 <- (nu_p_15_89 <  1 / lowest_time_to_treat ? 1 / lowest_time_to_treat :  nu_p_15_89)
      nu_e_0_14 <-   (nu_e_0_14 <  1 / lowest_time_to_treat ? 1 / lowest_time_to_treat :  nu_e_0_14) 
      nu_e_15_89 <- (nu_e_15_89 <  1 / lowest_time_to_treat ? 1 / lowest_time_to_treat :  nu_e_15_89)

      // Avg period infectious for pulmonary cases
      avg_nu_p <- (3 * nu_p_0_14 + 9 * nu_p_15_89) / e_age
      
      //Contact rate - sample
      CSample[age, age2] ~  truncated_gaussian(mean = polymod[age, age2], std = polymod_sd[age, age2], lower = 0)
      CSample[age, age2] <- (noise_switch == 1 ? CSample[age2, age] : polymod[age, age2])
      
      // Population
      N <- S + H + L + P + E + T_E + T_P
      NSum <- N[0, 0] + N[1, 0] +
        N[0, 1] + N[1, 1] +
        N[0, 2] + N[1, 2] +
        N[0, 3] + N[1, 3] +
        N[0, 4] + N[1, 4] +
        N[0, 5] + N[1, 5] +
        N[0, 6] + N[1, 6] +
        N[0, 7] + N[1, 7] + 
        N[0, 8] + N[1, 8] +
        N[0, 9] + N[1, 9] +
        N[0, 10] + N[1, 10] +
        N[0, 11] + N[1, 11] 
      
      //All-cause mortality excluding TB
      mu_all[age] ~ truncated_gaussian(mean = exp_life_span[age],
                                       std = exp_life_span[age]*0.05, lower = 0)
      mu_all <- (noise_switch == 1 ? mu_all : exp_life_span)
      mu[age] <- 1 / mu_all[age] - ((age < 3 ? mu_t_0_14 : (age < 11 ?  mu_t_15_69 : mu_t_70_89)) *
        (P[0, age] + P[1, age] + 
        E[0, age] + E[1, age] + T_E[0, age] + T_E[1, age]+ T_P[0, age] + 
        T_P[1, age])) / 
        (N[0, age] + N[1, age])
      mu[age] <-(mu[age] < 0 ? 0 : mu[age])
      
      //Average mortality
      avg_tb_mort <- (3 * mu_t_0_14 + 8 * mu_t_15_69 + mu_t_70_89) / e_age
      
      avg_mort <- (mu[0] + mu[1] + mu[2] + mu[3] + mu[4] + mu[5] +
        mu[6] + mu[7] + mu[8] + mu[9] + mu[10] + mu[11]) / e_age

      // Estimate the number of nonuk born cases
      inline nuk_start = (29 * yscale) //Start introducing non-UK born cases from 1960
      inline nuk_data = (69 * yscale)  //Start using data from 2000
      EstNUKCases[age] <- (t_now <  nuk_data ?  
                                (t_now < nuk_start ? 0 : 
                                   (non_uk_born_scaling == 1 ?   (t_now - nuk_start) / nuk_data * NUKCases2000[age] / (yscale) :
                                      //Estimate cases using a linear relationship based on cases in 2000:
                                      (non_uk_born_scaling == 2 ?  log(2 + t_now - nuk_start) / 
                                        log(2 + nuk_data - nuk_start) * NUKCases2000[age] : 
                                         //Assume that cases increased using a log link
                                         NUKCases2000[age]))) : //Assume nonUK born cases were constant from 1960 to 2000)))
                                  NonUKBornPCases[age])
      NoiseNUKCases[age] ~ truncated_gaussian(mean =  EstNUKCases[age] / MeasError, 
                                                    std =  MeasStd * EstNUKCases[age]  / MeasError, 
                                                    lower = 0)
      NoiseNUKCases <- (noise_switch == 1 ? NoiseNUKCases : EstNUKCases)
      
      // Estimate force of infection - start with probability of transmission
      inline modern_contacts = 69 * yscale // Modern day is 2000 with a baseline date of 1931
      inline scale_historic_contacts = (t_now > modern_contacts ? 0 : exp(-(t_now) / HistContactHalf))
      
      //Now build force of infection
      foi <- transpose(P) * I_bcg
      foi[age] <- (age < 3 ? rho_0_14 : (age < 11 ?  rho_15_69 : rho_70_89))
      * foi[age] + M * NoiseNUKCases[age] / (age < 3 ? nu_p_0_14 : nu_p_15_89)
      foi <- CSample * foi
      // i.e beta * foi / N
      foi <- ((avg_nu_p + avg_tb_mort + avg_mort) * (c_eff + c_hist * scale_historic_contacts) / TotalContacts) *
        foi / NSum
        
      // Account for age based adjustment if present
      foi[age = 0:2] <- (beta_df == 1 ? foi[age] : foi[age] * beta_child_mod)
      foi[11] <-  (beta_df < 3 ? foi[11] : foi[11] * beta_older_adult_mod)
      
      //Births
      // All used to fix births to deaths for testing (uncomment for this functionality)
      //death_sum[age] <-  ()N[1, age] + N[0, age]) / mu_all[age]
     // death_sum <- inclusive_scan(death_sum)
      births ~ gaussian(mean = births_input, std = 0.05 * births_input)
      //births <- (const_pop == 0 ? (noise_switch == 1 ? births_sample : births_input) : death_sum[e_age - 1] + theta[e_age - 1] * (N[0, e_age - 1] +  N[1, e_age - 1])) //Use to fix births to deaths
      births <-  (noise_switch == 1 ? births : births_input)
          
        ode(alg="RK4(3)", h = 1.0, atoler = 1e-3, rtoler = 1e-3) { 
            // Model equations
            dS[bcg, age]/dt = (
            // Disease model updates
            - (1 - (bcg == 1 ? chi[age] : 0)) * foi[age] * S[bcg, age]
            // Demographic model updates
            + (age == 0 ? (bcg == 1 ? gamma[age] * births : (1 - gamma[age]) * births) : 0) //Births
            + (age == 0 ? 0 : (bcg == 1 ? 
            (gamma[age] * theta[age - 1] *  S[0, age - 1] + theta[age - 1] *  S[1, age - 1]) :
                                 (1 - gamma[age]) * theta[age - 1] *  S[0, age - 1])) //Ageing into bucket
            - theta[age] * S[bcg, age] //Ageing out of bucket
            - mu[age] * S[bcg, age] //All cause (excluding TB) mortality
            ) 
   
            dH[bcg, age]/dt = (
            // Disease model updates
            + (1 - (bcg == 1 ? chi[age] : 0)) * foi[age] * S[bcg, age] 
            + (1 - delta) * foi[age] * L[bcg, age] 
            - (1 - (bcg == 1 ? alpha[age] : 0)) * 
            (age < 1 ? epsilon_h_0_4 : (age < 3 ?  epsilon_h_5_14 :   epsilon_h_15_89)) * H[bcg, age] 
            - (age < 1 ?  kappa_0_4 : (age < 3 ?  kappa_5_14 :  kappa_15_89)) * H[bcg, age]
            // Demographic model updates
            + (age == 0 ? 0 : theta[age - 1] *  H[bcg, age - 1]) //Ageing into bucket
            - theta[age] * H[bcg, age] //Ageing out of bucket
            - mu[age] * H[bcg, age] //All cause (excluding TB) mortality
            ) 
          
            dL[bcg, age]/dt = (
            // Disease model updates
            + (age < 1 ?  kappa_0_4 : (age < 3 ?  kappa_5_14 :  kappa_15_89)) * H[bcg, age]
            - (1 - delta) * foi[age] * L[bcg, age] 
            - (1 - (bcg == 1 ? alpha[age] : 0)) * 
            (age < 1 ? epsilon_l_0_4 : (age < 3 ?  epsilon_l_5_14 :   epsilon_l_15_89)) * L[bcg, age] 
            +  (age < 3 ? phi_0_14 : (age < 11 ?  phi_15_69 : phi_70_89)) * (T_E[bcg, age] + T_P[bcg, age])
            // Demographic model updates
            + (age == 0 ? 0 : theta[age - 1] *  L[bcg, age - 1]) //Ageing into bucket
            - theta[age] * L[bcg, age] //Ageing out of bucket
            - mu[age] * L[bcg, age] //All cause (excluding TB) mortality
            ) 
            
            dP[bcg, age]/dt = (
            // Disease model updates
            +  (age < 3 ? Upsilon_0_14 : (age < 11 ?  Upsilon_15_69 : Upsilon_70_89)) *
              (
                  (1 - (bcg == 1 ? alpha[age] : 0)) *  
                  (age < 1 ? epsilon_h_0_4 : (age < 3 ?  epsilon_h_5_14 :   epsilon_h_15_89)) * H[bcg, age] 
            +     (1 - (bcg == 1 ? alpha[age] : 0)) *
              (age < 1 ? epsilon_l_0_4 : (age < 3 ?  epsilon_l_5_14 :   epsilon_l_15_89)) * L[bcg, age]
              )   
            + (age < 3 ? zeta_0_14 : (age < 11 ?  zeta_15_69 : zeta_70_89)) * T_P[bcg, age] 
            - (age < 3 ? nu_p_0_14 : nu_p_15_89) * P[bcg, age]  
            - (age < 3 ? mu_t_0_14 : (age < 11 ?  mu_t_15_69 : mu_t_70_89)) * P[bcg, age]
            // Demographic model updates
            + (age == 0 ? 0 : theta[age - 1] *  P[bcg, age - 1]) //Ageing into bucket
            - theta[age] * P[bcg, age] //Ageing out of bucket
            - mu[age] * P[bcg, age] //All cause (excluding TB) mortality
            )
            
            dE[bcg, age]/dt = (
              // Disease model updates
              + (1 - (age < 3 ? Upsilon_0_14 : (age < 11 ?  Upsilon_15_69 : Upsilon_70_89))) *
                (
                  (1 - (bcg == 1 ? alpha[age] : 0)) * 
                  (age < 1 ? epsilon_h_0_4 : (age < 3 ?  epsilon_h_5_14 :   epsilon_h_15_89)) * H[bcg, age] 
            +     (1 - (bcg == 1 ? alpha[age] : 0)) * 
              (age < 1 ? epsilon_l_0_4 : (age < 3 ?  epsilon_l_5_14 :   epsilon_l_15_89)) * L[bcg, age]
              ) 
            + (age < 3 ? zeta_0_14 : (age < 11 ?  zeta_15_69 : zeta_70_89)) * T_E[bcg, age]
            - (age < 3 ? nu_e_0_14 : nu_e_15_89) * E[bcg, age]
            - (age < 3 ? mu_t_0_14 : (age < 11 ?  mu_t_15_69 : mu_t_70_89)) * E[bcg, age]
            // Demographic model updates
            + (age == 0 ? 0 : theta[age - 1] *  E[bcg, age - 1]) //Ageing into bucket
            - theta[age] * E[bcg, age] //Ageing out of bucket
            - mu[age] * E[bcg, age] //All cause (excluding TB) mortality
            ) 
            
            dT_E[bcg, age]/dt = (
              // Disease model updates
            + (age < 3 ? nu_e_0_14 : nu_e_15_89) * E[bcg, age]
            - (age < 3 ? zeta_0_14 : (age < 11 ?  zeta_15_69 : zeta_70_89)) * T_E[bcg, age] 
            - (age < 3 ? phi_0_14 : (age < 11 ?  phi_15_69 : phi_70_89)) * T_E[bcg, age] 
            - (age < 3 ? mu_t_0_14 : (age < 11 ?  mu_t_15_69 : mu_t_70_89)) * T_E[bcg, age]
            // Demographic model updates
            + (age == 0 ? 0 : theta[age - 1] *  T_E[bcg, age - 1]) //Ageing into bucket
            - theta[age] * T_E[bcg, age] //Ageing out of bucket
            - mu[age] * T_E[bcg, age] //All cause (excluding TB) mortality
            ) 
            
            dT_P[bcg, age]/dt = (
            // Disease model updates
            + (age < 3 ? nu_p_0_14 : nu_p_15_89) * P[bcg, age]
            - (age < 3 ? zeta_0_14 : (age < 11 ?  zeta_15_69 : zeta_70_89)) * T_P[bcg, age] 
            - (age < 3 ? phi_0_14 : (age < 11 ?  phi_15_69 : phi_70_89)) * T_P[bcg, age] 
            - (age < 3 ? mu_t_0_14 : (age < 11 ?  mu_t_15_69 : mu_t_70_89)) * T_P[bcg, age]
            // Demographic model updates
            + (age == 0 ? 0 : theta[age - 1] *  T_P[bcg, age - 1]) //Ageing into bucket
            - theta[age] * T_P[bcg, age] //Ageing out of bucket
            - mu[age] * T_P[bcg, age] //All cause (excluding TB) mortality
            ) 
            //Accumalator states
            dYearlyPulCases[bcg, age]/dt = ((age < 3 ? nu_p_0_14 : nu_p_15_89) * P[bcg, age])
            dYearlyEPulCases[bcg, age]/dt = ((age < 3 ? nu_e_0_14 : nu_e_15_89) * E[bcg, age]) 
            dYearlyDeaths[bcg, age]/dt = (age < 3 ? mu_t_0_14 : (age < 11 ?  mu_t_15_69 : mu_t_70_89)) *
              (T_E[bcg, age] + T_P[bcg, age] + P[bcg, age] + E[bcg, age])
            
          }

      // Reporting states
      //By year all summarised reporting states
      YearlyPAgeCases[age] <-  YearlyPulCases[0, age] + YearlyPulCases[1, age]
      YearlyPCases <- YearlyPAgeCases[0] + YearlyPAgeCases[1] + YearlyPAgeCases[2] + 
        YearlyPAgeCases[3] + YearlyPAgeCases[4] + YearlyPAgeCases[5] + 
        YearlyPAgeCases[6] + YearlyPAgeCases[7] + YearlyPAgeCases[8] + 
        YearlyPAgeCases[9] + YearlyPAgeCases[10] + YearlyPAgeCases[11]
      
      YearlyEAgeCases[age] <-  YearlyEPulCases[0, age] + YearlyEPulCases[1, age]
      YearlyECases <- YearlyEAgeCases[0] + YearlyEAgeCases[1] + YearlyEAgeCases[2] + 
        YearlyEAgeCases[3] + YearlyEAgeCases[4] + YearlyEAgeCases[5] + 
        YearlyEAgeCases[6] + YearlyEAgeCases[7] + YearlyEAgeCases[8] + 
        YearlyEAgeCases[9] + YearlyEAgeCases[10] + YearlyEAgeCases[11]
      
      YearlyAgeCases <- YearlyPAgeCases + YearlyEAgeCases
      YearlyCases <- YearlyPCases + YearlyECases
      
    }
    
    sub observation {
      
      YearlyHistPInc ~ truncated_gaussian(MeasError * (YearlyPCases + 
        NoiseNUKCases[0] + NoiseNUKCases[1] + NoiseNUKCases[2] + 
        NoiseNUKCases[3] + NoiseNUKCases[4] + NoiseNUKCases[5] + 
        NoiseNUKCases[6] + NoiseNUKCases[7] + NoiseNUKCases[8] + 
        NoiseNUKCases[9] + NoiseNUKCases[10] + NoiseNUKCases[11]), 
                                          MeasStd * (YearlyPCases +
                                            NoiseNUKCases[0] + NoiseNUKCases[1] + NoiseNUKCases[2] + 
                                            NoiseNUKCases[3] + NoiseNUKCases[4] + NoiseNUKCases[5] + 
                                            NoiseNUKCases[6] + NoiseNUKCases[7] + NoiseNUKCases[8] + 
                                            NoiseNUKCases[9] + NoiseNUKCases[10] + NoiseNUKCases[11]), 
                                          0)
      YearlyInc ~ truncated_gaussian(MeasError * YearlyCases,
                                     MeasStd * YearlyCases,
                                     0)
      YearlyAgeInc[age] ~ truncated_gaussian(MeasError * YearlyAgeCases[age], MeasStd * YearlyAgeCases[age],
                                             0)
      YearlyChildInc ~ truncated_gaussian(MeasError * (YearlyAgeCases[0] + YearlyAgeCases[1] + YearlyAgeCases[2]), 
                                          MeasStd * (YearlyAgeCases[0] + YearlyAgeCases[1] + YearlyAgeCases[2]), 
                                          0)
      YearlyAdultInc ~ truncated_gaussian(MeasError * (YearlyAgeCases[3] + YearlyAgeCases[4] + YearlyAgeCases[5]
                                    + YearlyAgeCases[6] + YearlyAgeCases[7] + YearlyAgeCases[8]
                                    + YearlyAgeCases[9] + YearlyAgeCases[10]),
                                    MeasStd * (YearlyAgeCases[3] + YearlyAgeCases[4] + YearlyAgeCases[5]
                                                 + YearlyAgeCases[6] + YearlyAgeCases[7] + YearlyAgeCases[8]
                                                 + YearlyAgeCases[9] + YearlyAgeCases[10]),
                                                 0)
      YearlyOlderAdultInc ~ truncated_gaussian(MeasError * YearlyAgeCases[11], 
                                               MeasStd * YearlyAgeCases[11], 
                                                                       0)
      
    }
}
