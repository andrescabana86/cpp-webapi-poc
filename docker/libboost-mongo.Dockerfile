FROM ubuntu:23.04
LABEL maintainer="andrescabana86 <andrescabana86@gmail.com>"

# to update the image in dockerfile
# Before pushing the image to Docker Hub, you need to tag your image with a Docker Hub repository name, for example:
## docker tag [IMAGE_ID]:[TAG] andrescabana86/libboost-mongo:[TAG]
## docker push andrescabana86/libboost-mongo:[TAG]

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# Install necessary dependencies
RUN apt-get -y update  \
    && apt-get -y upgrade \
    && apt-get install -y --no-install-recommends \
        libz-dev \
        libssl-dev \
        libcurl4-gnutls-dev \
        libexpat1-dev \
        gettext \
        cmake \
        gcc \
        build-essential \
        libboost-all-dev \
        libtcmalloc-minimal4 \
        autoconf \
        automake \
        libtool \
        pkg-config \
        apt-transport-https \
        ca-certificates \
        software-properties-common \
        wget \
        curl \
        gnupg \
        zlib1g-dev \
        swig \
        vim \
        gdb \
        valgrind \
        locales \
        locales-all \
    && ln -s /usr/lib/libtcmalloc_minimal.so.4 /usr/lib/libtcmalloc_minimal.so \
    && apt-get clean

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

WORKDIR /app
