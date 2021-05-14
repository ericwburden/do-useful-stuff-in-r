FROM r-base:4.0.5

MAINTAINER Eric Burden "eric.w.burden@gmail.com"

RUN apt-get update && apt-get install -y \
    sudo \
    gdebi-core \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    xtail \
    wget

RUN R -e "install.packages(c('shiny', 'rmarkdown', 'learnr', 'bslib'), repos='https://cloud.r-project.org/')"
RUN wget https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-1.5.16.958-amd64.deb
RUN gdebi -n shiny-server-1.5.16.958-amd64.deb
RUN rm shiny-server-1.5.16.958-amd64.deb

RUN rm /srv/shiny-server/index.html && rm -rf /srv/shiny-server/sample-apps
COPY shiny-server.conf /etc/shiny-server/shiny-server.conf
RUN echo "local({options(shiny.port=3838, shiny.host='0.0.0.0')})" > /usr/lib/R/etc/Rprofile.site

RUN chown -R shiny:shiny /var/lib/shiny-server
RUN chown -R shiny:shiny /var/log/shiny-server

COPY shiny-server.sh /usr/bin/shiny-server.sh
RUN chown shiny:shiny /usr/bin/shiny-server.sh

COPY apps/nav/ /srv/shiny-server
COPY apps/learnr-apps /srv/shiny-server/tutorial
COPY R/ /usr/bin/learnr
RUN chown -R shiny:shiny /srv/shiny-server

RUN echo "CONTAINERIZED=\"TRUE\"" >> /usr/lib/R/etc/Renviron.site

EXPOSE 3838

USER shiny

CMD ["/usr/bin/shiny-server.sh"]
