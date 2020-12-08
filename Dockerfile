

FROM rocker/r-ver:4.0.2

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


# Download and install shiny server
RUN wget --no-verbose https://download3.rstudio.org/ubuntu-14.04/x86_64/VERSION -O "version.txt" && \
    VERSION=$(cat version.txt)  && \
    wget --no-verbose "https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-$VERSION-amd64.deb" -O ss-latest.deb && \
    gdebi -n ss-latest.deb && \
    rm -f version.txt ss-latest.deb && \
    . /etc/environment && \
    R -e "install.packages(c('shinyjs', 'shiny', 'rmarkdown'))" && \
    R -e "install.packages(c('png', 'jpeg', 'RCurl'))" && \
    cp -R /usr/local/lib/R/site-library/shiny/examples/* /srv/shiny-server/ && \
    chown shiny:shiny /var/lib/shiny-server

# Install latest colorspace version from r-forge
RUN cd /tmp && \
    svn checkout svn://r-forge.r-project.org/svnroot/colorspace/pkg/colorspace && \
    R CMD INSTALL colorspace && \
    rm -rf /srv/shiny-server/* && \
    cp -r colorspace/inst/* /srv/shiny-server/
#RUN ls -l /srv/shiny-server


EXPOSE 3838

COPY shiny-server.sh /usr/bin/shiny-server.sh

CMD ["/usr/bin/shiny-server.sh"]
