# Modelling BCG vaccination in the UK: What is the impact of changing policy?


[![badge](https://img.shields.io/badge/Development-Environment-lightblue.svg)](https://mybinder.org/v2/gh/seabbs/thesis/master?urlpath=rstudio) [![Thesis](https://img.shields.io/badge/Thesis-click%20here!-lightgrey.svg?style=flat)](https://www.samabbott.co.uk/thesis) [![DOI](https://zenodo.org/badge/65387003.svg)](https://zenodo.org/badge/latestdoi/65387003)

By: [Sam Abbott](https://www.samabbott.co.uk)

Supervised by: [Hannah Christensen](https://research-information.bristol.ac.uk/en/persons/hannah-christensen(cea299d9-5ef7-4c68-a931-28415798e10e).html), [and Ellen Brooks-Pollock](https://research-information.bristol.ac.uk/en/persons/ellen-brooks-pollock(9ffd9ff9-0949-49c4-97f7-bae51aa23d51).html)

A dissertation submitted to the University of Bristol in accordance with the requirements for award of the degree of Doctor of Philosophy in the Faculty of Health Sciences on the 8th of August 2019.

## Abstract 

Bacillus Calmette–Guérin (BCG) remains the only licensed vaccine against Tuberculosis (TB). In 2005, England changed from universal vaccination of school-age children to targeted vaccination of high-risk neonates. Little work has been done to assess the impact of this policy change. This thesis evaluates the impact of this change.

Whilst the characteristics of TB in England have been reported elsewhere, little attention has been given to the role of BCG. Consequently, I explored and combined, the available data sources. Reporting on data quality issues, trends in incidence rates and differences in outcomes stratified by BCG status. 

Prior to the change in policy, several studies were carried out to assess the impact. I recreated one such study and found that there was a greater impact than previously thought. 
Determining the benefits of being BCG vaccinated is necessary to properly assess the impact of the policy change. I evaluated the evidence that vaccination may improve outcomes for TB cases in England and found that there was some evidence of an association between vaccination and reduced mortality. 

Surveillance data can help assess whether changes in vaccination policy have influenced incidence rates. I used surveillance data to determine whether those at school-age, or neonates, were directly affected by the policy change. I found the policy change was associated with increased notifications in the UK born but this was outweighed by a reduction in notifications in the non-UK born. 

Statistical modelling is restricted by the available data. Therefore, I developed a dynamic model of TB, fit to available data, to forecast the impact of the policy change. Although the fit to the data was poor the forecasts suggested that continuing school-age vaccination reduced TB incidence compared with neonatal vaccination. Neonatal vaccination reduced incidence in children but had little impact on other age groups.

## Chapters

Links to external chapter resources are given below.

##### Chapter 3 - getTBinR: an R package for accessing and summarising the World Health Organization Tuberculosis data


[![badge](https://img.shields.io/badge/launch-getTBinR-579ACA.svg?logo=data:image/png;base64,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)](https://mybinder.org/v2/gh/seabbs/getTBinR/master?urlpath=rstudio) [![CRAN\_Release\_Badge](http://www.r-pkg.org/badges/version-ago/getTBinR)](https://CRAN.R-project.org/package=getTBinR) [![Documentation via pkgdown](https://img.shields.io/badge/Documentation-click%20here!-lightgrey.svg?style=flat)](https://www.samabbott.co.uk/getTBinR/) [![metacran monthly downloads](http://cranlogs.r-pkg.org/badges/getTBinR)](https://cran.r-project.org/package=getTBinR) [![metacran downloads](http://cranlogs.r-pkg.org/badges/grand-total/getTBinR?color=ff69b4)](https://cran.r-project.org/package=getTBinR) [![DOI](https://zenodo.org/badge/112591837.svg)](https://zenodo.org/badge/latestdoi/112591837) [![DOI](http://joss.theoj.org/papers/10.21105/joss.01260/status.svg)](https://doi.org/10.21105/joss.01260)

##### Chapter 5 - Reassessing the Evidence for Universal School-age Bacillus Calmette Guerin (BCG) Vaccination in England and Wales

[![badge](https://img.shields.io/badge/Launch-Analysis-lightblue.svg)](https://mybinder.org/v2/gh/seabbs/AssessBCGPolicyChange/master?urlpath=rstudio) [![Documentation](https://img.shields.io/badge/Documentation-click%20here!-lightgrey.svg?style=flat)](https://www.samabbott.co.uk/AssessBCGPolicyChange) [![Paper](https://img.shields.io/badge/Paper-10.1101/567511-lightgreen.svg)](https://doi.org/10.1101/567511) [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.2635687.svg)](https://doi.org/10.5281/zenodo.2635687)

##### Chapter 6 - Exploring the effects of BCG vaccination in patients diagnosed with tuberculosis: observational study using the Enhanced Tuberculosis Surveillance system

[![badge](https://img.shields.io/badge/Launch-Analysis-lightblue.svg)](https://mybinder.org/v2/gh/seabbs/ExploreBCGOnOutcomes/master?urlpath=rstudio)
[![Paper](https://img.shields.io/badge/Paper-10.1016/j.vaccine.2019.06.056-lightgreen.svg)](https://doi.org/10.1016/j.vaccine.2019.06.056)
[![Preprint](https://img.shields.io/badge/Preprint-10.1101/366476-lightgrey.svg)](https://doi.org/10.1101/366476)
[![DOI](https://zenodo.org/badge/127124135.svg)](https://zenodo.org/badge/latestdoi/127124135)

##### Chapter 7 - Estimating the effect of the 2005 change in BCG policy in England: A retrospective cohort study

[![badge](https://img.shields.io/badge/Launch-Analysis-lightblue.svg)](https://mybinder.org/v2/gh/seabbs/DirectEffBCGPolicyChange/master?urlpath=rstudio) [![Documentation](https://img.shields.io/badge/Documentation-click%20here!-lightgrey.svg?style=flat)](https://www.samabbott.co.uk/DirectEffBCGPolicyChange) [![Paper](https://img.shields.io/badge/Paper-10.1101/567511-lightgreen.svg)](https://doi.org/10.1101/567511) [![DOI](https://zenodo.org/badge/173767331.svg)](https://zenodo.org/badge/latestdoi/173767331)

##### Chapter 8 - Devoloping a dynamic transmission model of Tuberculosis

[![Documentation](https://img.shields.io/badge/Documentation-click%20here!-lightgrey.svg?style=flat)](https://www.samabbott.co.uk/ModelTBBCGEngland)
[![DOI](https://zenodo.org/badge/140855004.svg)](https://zenodo.org/badge/latestdoi/140855004)

All links for Chapter 8 also apply to Chapters 9 and 10 as well.

## Citing

Please cite the individual chapter papers/resources as appropriate if used in your work.

## Reproducibility

### Repository structure

This repository has the following structure:

- `rmds`: Thesis chapters as Rmd's.
- `docs`: Formatted PhD thesis (`html` + `pdf`).
- `plan`: Initial aims and objectives + in progress planning.
- `packrat`: All R packages required.

See individual chapter text and Rmd documents for additional reproducibility information.

### Data

All chapters can be built using the data available in this repository. However the raw data cannot be shared freely. See [`tbinenglanddataclean`](https://www.samabbott.co.uk/tbinenglanddataclean/) for instructions as to the data sources that need to be applied for to reproduce each chapter in this thesis completely. The results in analysis chapters have been ported from their original, fully reproducible repositories. See these repositories for details.

### Manual install

- Install R (analysis run with `3.5.3`) and Rstudio (alternatively use Docker as outlined below).

- Download the folder from [https://github.com/seabbs/thesis/archive/master.zip](https://github.com/seabbs/thesis/archive/master.zip) or use `git clone`, as follows, in the command line (not the R terminal).

``` bash
git clone https://github.com/seabbs/thesis.git
```

- Once this has been downloaded click on the project file (`thesis.Rproj`).

- Install thesis dependencies using the following. 

``` r 
#install.packages("packrat")
packrat::restore()
# If latex is not installed: tinytex::install_tinytex()
```

- Build the thesis using `make`. Alternatively see the `index` folder for individual chapters.

- See the individual repositories for each chapter for full reproducibility details.

### Docker

This thesis was developed in a docker container based on the [tidyverse](https://hub.docker.com/r/rocker/tidyverse/) docker image. To run the docker image run:

``` bash
docker run -d -p 8787:8787 --name thesis --mount type=bind,source=$(pwd)/data/tb_data,target=/home/rstudio/thesis/data -e USER=thesis -e PASSWORD=thesis seabbs/thesis
```

The rstudio client can be found on port `:8787` at your local machines ip. The default username:password is thesis:thesis, set the user with `-e USER=username`, and the password with `- e PASSWORD=newpasswordhere`. The default is to save the analysis files into the user directory. If running without the accomanying data then remove `--mount type=bind,source=$(pwd)/data/tb_data,target=/home/rstudio/thesis/data`.


Alternatively the analysis environment can be accessed via [binder](https://mybinder.org/v2/gh/seabbs/seabbs/master?urlpath=rstudio).


