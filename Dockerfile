FROM gcc:7.3.0 as baseline
# Set the working directory to /app
WORKDIR /app

RUN apt-get -qq update
RUN apt-get -qq upgrade
RUN apt-get -qq install cmake

RUN apt-get -qq install libboost-all-dev
RUN apt-get -qq install build-essential libtcmalloc-minimal4 \
    && ln -s /usr/lib/libtcmalloc_minimal.so.4 /usr/lib/libtcmalloc_minimal.so

FROM baseline
# Copy the current directory contents into the container at /app
COPY . /app

# Compile the C++ application
# RUN g++ -o webapi src/main.cpp

# Set the command to run the executable
# CMD ["./webapi"]