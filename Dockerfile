FROM ubuntu:23.04 as baseline
RUN apt-get -qq -y update
RUN apt-get -qq -y upgrade
RUN apt-get -qq -y install cmake

FROM baseline as libs
RUN apt-get -qq -y install build-essential libboost-all-dev
RUN apt-get -qq -y install libtcmalloc-minimal4 \
    && ln -s /usr/lib/libtcmalloc_minimal.so.4 /usr/lib/libtcmalloc_minimal.so

FROM libs
# at /app
WORKDIR /app
# Copy the current directory contents into the container at /app
COPY . /app

# Compile the C++ application
RUN g++ -o webapi src/main.cpp

# Set the command to run the executable
CMD ["./webapi"]