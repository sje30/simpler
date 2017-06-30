FROM andrewosh/binder-base

MAINTAINER Stephen Eglen <sje30@cam.ac.uk>

USER root


RUN apt-key adv --keyserver keys.gnupg.net --recv-key 381BA480
RUN echo "deb http://cran.rstudio.com/bin/linux/debian jessie-cran3/" >> /etc/apt/sources.list

# Retrieve recent R binary from CRAN
RUN apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq --force-yes \
        libzmq3-dev r-base-core r-recommended r-base r-base-dev libcurl4-openssl-dev && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/*

# Set default CRAN repo
RUN echo 'options("repos"="http://cran.rstudio.com")' >> /usr/lib/R/etc/Rprofile.site

USER main

RUN mkdir $HOME/r-libs
ENV R_LIBS $HOME/r-libs

RUN Rscript -e "install.packages(c('curl', 'devtools', 'dplyr', 'seasonal', 'stringr', 'readr'))"


## taken from https://github.com/IRkernel/IRkernel                              
RUN Rscript -e "devtools::install_github('IRkernel/IRkernel'); IRkernel::installspec()"
