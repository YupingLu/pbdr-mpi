FROM rocker/r-base
MAINTAINER "Yuping Lu" yupinglu89@gmail.com

RUN apt-get update      \
  && apt-get install -y \
    wget                \
    python              \
    ssh                 \
    libopenblas-dev     \
    libopenmpi-dev      \
    mkdir /usr/local/openmpi || echo "Directory exists"  \
    mkdir /opt/mellanox || echo "Directory exists"  \
    mkdir /all_hostlibs || echo "Directory exists"  \
    mkdir /desired_hostlibs || echo "Directory exists"  \
    mkdir /etc/libibverbs.d || echo "Directory exists"  \
    echo "driver mlx4" > /etc/libibverbs.d/mlx4.driver  \
    echo "driver mlx5" > /etc/libibverbs.d/mlx5.driver  \
    adduser ylk || echo "User exists"  \
    wget https://gist.githubusercontent.com/l1ll1/89b3f067d5b790ace6e6767be5ea2851/raw/422c8b5446c6479285cd29d1bf5be60f1b359b90/desired_hostlibs.txt -O /tmp/desired_hostlibs.txt   \
    cat /tmp/desired_hostlibs.txt | xargs -I{} ln -s /all_hostlibs/{} /desired_hostlibs/{}  \
    rm /tmp/desired_hostlibs.txt

# some CRAN dependencies
RUN apt-get install -y \
  r-cran-curl

RUN r -e "install.packages(c('rlecuyer', 'remotes', 'randomForest'), \
  repos='https://cran.rstudio.com/', dependencies='Imports')"

ENV COLOROUT_VERSION 1.1-2
RUN cd /tmp \
  && wget https://github.com/jalvesaq/colorout/releases/download/v1.2-2/colorout_1.1-2.tar.gz \
  && tar zxf colorout_1.1-2.tar.gz \
  && R CMD INSTALL colorout/ \
  && rm colorout_1.1-2.tar.gz \
  && rm -rf colorout/

# install latest pbdR packages from github
RUN r -e "                                      \
  remotes::install_github('RBigData/pbdMPI')  ; \
"

# some quality of life stuff
RUN echo "alias R='R --no-save --quiet'" >> /etc/bash.bashrc
RUN echo "options(repos=structure(c(CRAN='https://cran.rstudio.com/'))) ; \
  utils::rc.settings(ipck=TRUE);                                          \
  library(colorout);                                                      \
  " > /usr/lib/R/etc/Rprofile.site

# use openblas
RUN update-alternatives --set libblas.so.3 /usr/lib/openblas-base/libblas.so.3

# cleanup
RUN rm -rf /tmp/*
RUN apt-get remove -y --purge python wget
RUN apt-get autoremove -y
RUN apt-get autoclean

# create an R user
ENV HOME /home/ylk
RUN useradd --create-home --home-dir $HOME ylk \
  && chown -R ylk:users $HOME

WORKDIR $HOME
USER ylk

# default command
CMD ["bash"]
