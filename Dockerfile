## Start with the tidyverse docker image
FROM rocker/tidyverse:latest

MAINTAINER "Sam Abbott" contact@samabbott.co.uk

RUN apt-get install -y \
    libproj-dev \
    libgdal-dev \
    && apt-get clean
 
## Get JAVA
RUN apt-get update -qq \
  && apt-get -y --no-install-recommends install \
    default-jdk \
    default-jre \
  && R CMD javareconf
  
ADD . /home/rstudio/seabbs.github.io

RUN Rscript -e 'source("https://bioconductor.org/biocLite.R"); biocLite("Biobase")'
RUN Rscript -e 'devtools::install_github("rstudio/blogdown")'

RUN Rscript -e  'blogdown::install_hugo()'

## Get latest release of h2o
RUN Rscript -e 'install.packages("h2o", type="source", repos="http://h2o-release.s3.amazonaws.com/h2o/rel-wright/2/R")'
 
RUN git config --global user.email "signin@samabbott.co.uk"
RUN git config --global user.name "seabbs"

