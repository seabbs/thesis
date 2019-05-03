## Start with the tidyverse docker image
FROM rocker/verse:3.5.3

MAINTAINER "Sam Abbott" contact@samabbott.co.uk

RUN apt-get update \
  && apt-get install -y \
  libudunits2-dev \
  libqpdf-dev \
  libnetcdf-dev \
  && apt-get clean
  
ADD . /home/rstudio/thesis

WORKDIR /home/rstudio/thesis

RUN Rscript -e "install.packages('packrat'); packrat::restore()"
