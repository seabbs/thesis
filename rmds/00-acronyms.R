

## Structure latex
latex_abr <- function(abr, desc) {
  paste0("\\textbf{", abr, "} - ", desc, " \\par")
}


## Define acronyms
abr_df <- tibble::tribble(
  ~abr, ~desc,
  "AIC", "Akaike Information Criterion",
  "DIC", "Deviance Information Criterion",
  "POLYMOD", "Improving Public Health Policy in Europe through the Modelling and Economic Evaluation of Interventions for the Control of Infectious Diseases",
  "MNAR", "Missing Not at Random",
  "MCAR", "Missing Completely at Random",
  "MAR", "MissingaAt Random",
  "IRR", "Incidence Rate Ratio",
  "SE", "Standard Error",
  "RR", "Risk Ratio",
  "COVER", "Cover of Vaccination Evaluated Rapidly ",
  "MRC", "Medical Research Council",
  "UK", "United Kingdom",
  "aHR", "adjusted Hazard Ratio",
  "IMD", "Index of Multiple Deprivation ",
  "CI", "Confidence Interval",
  "CrI", "Credible Interval",
  "IQR", "Interquartile Range",
  "MDR", "Multi-drug Resistant",
  "CRAN", "Comprehensive R Archive Network",
  "OR", "Odds Ratio",
  "aOR", "adjusted Odds Ratio",
  "DHSS", "Department of Health and Social Security",
  "LOOIC", "Leave One Out Information Criterion",
  "SD", "Standard Deviation",
  "LRT", "Likelihood Ratio Test",
  "LOESS", "Locally Estimated Scatterplot Smoothing",
  "ABC", "Approximate Bayesian Computation",
  "BCG", "Bacillus Calmette–Guérin",
  "DOTS", "Directly Observed Treatment Short-course",
  "ETS",  "Enhanced Tuberculosis Surveillance System",
  "HIV",  "Human Immunodeficiency Viruse",
  "JCVI", "Joint Committee on Vaccination and Immunisation",
  "LFS",  "Labour Force Survey",
  "MCMC", "Markov Chain Monte Carlo",
  "MRSA", "Methicillin-resistant *Staphylococcus aureus*",
  "ONS",  "Office for National Statistics", 
  "PHE",  "Public Health England",
  "PMCMC", "Particle Markov Chain Monte Carlo",
  "PRCC", "Partial Rank Correlation Coefficient",
  "SMC", "Sequential Monte Carlo", 
  "SMC-SMC", "Sequential Monte Carlo - Sequential Monte Carlo",
  "TB", "Tuberculosis",
  "TST", "Tuberculin Skin Testing",
  "WHO", "World Health Organization",
  "NTM", "Non-Tuberculosis Mycobacteria"
)

## Order by A-Z
abr_df <- abr_df[order(abr_df$abr), ]

## Add latex formating to each entry
abr_df <- dplyr::mutate(abr_df, latex = latex_abr(abr, desc))


## Pull output into a single latex string and print
linked_output <- paste(abr_df$latex, collapse = " ")
print(linked_output)
