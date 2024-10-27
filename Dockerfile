FROM --platform=linux/amd64 rocker/rstudio:4.3.3

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
  libgdal30 \
  libgeos-c1v5 \
  libglpk40 \
  libglu1-mesa \
  libjq1 \
  libpq-dev \
  libproj22 \
  libprotobuf23 \
  libudunits2-0 \
  libxml2 \
  openjdk-11-jre-headless \
  && R CMD javareconf \
  && rm -rf /var/lib/apt/lists/*

# Install renv
RUN Rscript -e 'install.packages("remotes")'
RUN Rscript -e 'remotes::install_github("rstudio/renv@v1.0.7")'

# Install packages
## Set path for cache
ENV RENV_PATHS_CACHE /home/rstudio/.cache/R/renv
## Set the path for the project library (to avoid overwriting the local library)
ENV RENV_PATHS_LIBRARY /home/rstudio/.library
## Copy renv auto-loader
WORKDIR /home/pkg
RUN mkdir -p renv
COPY renv.lock .
COPY .Rprofile .
COPY renv/activate.R renv/activate.R
COPY renv/settings.json renv/settings.json
## Restore library
RUN Rscript -e 'renv::restore()'

# Install TinyTex
ENV HOME /home/rstudio
ENV TINYTEX_INSTALLER TinyTeX-1
RUN wget -qO- "https://yihui.org/tinytex/install-bin-unix.sh" | sh
RUN ${HOME}/bin/tlmgr install csquotes

# Set the config file to open the project when launching rstudio server
ARG FILE=/home/rstudio/.local/share/rstudio/projects_settings/last-project-path
ARG PRJ=/home/rstudio/sdm-pkg-plurality-tutorials\
/sdm-pkg-plurality-tutorials.Rproj
RUN mkdir -p "$(dirname $FILE)" && touch ${FILE} && echo ${PRJ} >> ${FILE}

# Give ownership to rstudio user
RUN chown -R rstudio /home/rstudio
