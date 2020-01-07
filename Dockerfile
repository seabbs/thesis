## Start with the tidyverse docker image
FROM rocker/verse:3.5.3

MAINTAINER "Sam Abbott" contact@samabbott.co.uk

RUN apt-get update \
  && apt-get install -y \
  libudunits2-dev \
  libqpdf-dev \
  libnetcdf-dev \
  && apt-get clean

## Add in tinytex install in docker
RUN wget -qO- \
    "https://github.com/yihui/tinytex/raw/master/tools/install-unx.sh" | \
    sh -s - --admin --no-path \
  && mv ~/.TinyTeX /opt/TinyTeX \
  && /opt/TinyTeX/bin/*/tlmgr path add \
  && tlmgr install metafont mfware inconsolata tex ae parskip listings \
  && tlmgr path add \
  && Rscript -e "source('https://install-github.me/yihui/tinytex'); tinytex::r_texmf()" \
  && chown -R root:staff /opt/TinyTeX \
  && chmod -R g+w /opt/TinyTeX \
  && chmod -R g+wx /opt/TinyTeX/bin \
  
ADD . /home/rstudio/thesis

WORKDIR /home/rstudio/thesis

RUN Rscript -e "install.packages('packrat'); packrat::restore()"
