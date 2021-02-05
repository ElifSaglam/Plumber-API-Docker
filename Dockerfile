FROM r-base:4.0.2

RUN apt-get update -qq && apt-get install -y \
        git \
        libssl-dev \
        libcurl4-gnutls-dev \
        curl \
        libsodium-dev \
        libpq-dev \
        sudo \
        libxml2-dev \
		libgdal-dev \
		libudunits2-dev \
		libsodium-dev \
		libfontconfig1-dev \
		libcairo2-dev \
		openjdk-8-jdk \
		openjdk-8-jre

RUN apt-get update && sudo apt-get install pandoc -y

RUN apt-get update && sudo apt-get install libmysqlclient-dev -y

RUN R CMD javareconf JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/

RUN apt-get update && apt-get install locales -y

RUN R -e 'install.packages("dplyr")'
RUN R -e 'install.packages("plumber")'
RUN R -e 'install.packages("plotly")'
RUN R -e 'install.packages("gridExtra")'
RUN R -e 'install.packages("leaflet")'
RUN R -e 'install.packages("grid")'
RUN R -e 'install.packages("jsonlite")'

RUN mkdir -p /usr/local/src/PlumberAPI
COPY . /usr/local/src/PlumberAPI
WORKDIR /usr/local/src/PlumberAPI

EXPOSE 8000

ENTRYPOINT ["R","-e","pr <- plumber::plumb(commandArgs()[4]); pr$run(host='0.0.0.0', port=8000)"]
CMD ["plumber.R"]
