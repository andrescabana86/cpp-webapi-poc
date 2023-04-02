FROM ubuntu:23.04
LABEL maintainer="andrescabana86 <andrescabana86@gmail.com>"

RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y install libz-dev libssl-dev libcurl4-gnutls-dev libexpat1-dev gettext cmake gcc build-essential libboost-all-dev
RUN apt-get -y install libtcmalloc-minimal4 \
    && ln -s /usr/lib/libtcmalloc_minimal.so.4 /usr/lib/libtcmalloc_minimal.so

WORKDIR /tmp

RUN curl -o git.tar.gz https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.9.5.tar.gz
RUN tar -zxf git.tar.gz

WORKDIR /tmp/git-2.9.5

RUN make prefix=/usr/local all
RUN make prefix=/usr/local install

WORKDIR /usr/src

RUN git clone https://github.com/mongodb/mongo-c-driver.git \
&& cd mongo-c-driver && git checkout 1.23.2 \
&& mkdir cmake-build && cd cmake-build \
&& cmake -DENABLE_AUTOMATIC_INIT_AND_CLEANUP=OFF .. \
&& make && make install && ldconfig /usr/lib

RUN git clone https://github.com/mongodb/mongo-cxx-driver.git \
--branch releases/v3.7 --depth 1 \
&& cd mongo-cxx-driver/build && cmake \
-DBSONCXX_POLY_USE_MNMLSTC=1 \
-DCMAKE_BUILD_TYPE=Release \
-DCMAKE_INSTALL_PREFIX=/usr \
-DLIBMONGOC_DIR=/usr/lib/x86_64-linux-gnu \
-DLIBBSON_DIR=/usr/lib/x86_64-linux-gnu \
-DCMAKE_MODULE_PATH=/usr/src/mongo-cxx-driver-r3.7.0/cmake .. \
&& make EP_mnmlstc_core && make && make install && ldconfig /usr