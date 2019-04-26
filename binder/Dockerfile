FROM rocker/binder:3.5.3

USER root

RUN apt-get update \
&& apt-get install -y \
libudunits2-dev \
libqpdf-dev \
libnetcdf-dev \
&& apt-get clean

COPY . ${HOME}
RUN chown -R ${NB_USER} ${HOME}

## Become normal user again
USER ${NB_USER}

RUN R -e "packrat::restore()"

RUN R -e "source('.Rprofile'); install.packages('tinytex'); tinytex::install_tinytex()"