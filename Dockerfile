
# Updated: 2023-09-28, RS

# Install dedicated R version with shiny server
FROM rocker/shiny:4.3.0

LABEL maintainer "Reto Stauffer <reto.stauffer@uibk.ac.at>"

# Installing required packages
RUN apt-get update && apt-get install -y \
    sudo \
    gdebi-core \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    xtail \
    subversion \
    wget

# (1) Install required packages
# (2) Switch to /tmp folder and clone the current version of colorspace
# (3) Install the colorspace package
# (4) Empty the /srv/shiny-server/ folder; removing demo apps
# (5) Move colorspace shiny apps (from inst folder) to the exposed shiny-server folder
# (6) Cleaning up
RUN R -e "install.packages(c('shinyjs', 'shiny', 'rmarkdown'))" && \
    R -e "install.packages(c('png', 'jpeg', 'RCurl'))" && \
    cd /tmp && \
    svn checkout svn://r-forge.r-project.org/svnroot/colorspace/pkg/colorspace && \
    R CMD INSTALL colorspace && \
    rm -rf /srv/shiny-server/* && \
    cp -r /tmp/colorspace/inst/* /srv/shiny-server/ && \
    rm -rf /tmp/colorspace

# Expose shiny application on port 3838
EXPOSE 3838

#COPY shiny-server.sh /usr/bin/shiny-server.sh

CMD ["/usr/bin/shiny-server"]
