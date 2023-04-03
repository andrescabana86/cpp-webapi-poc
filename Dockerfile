FROM andrescabana86/libboost-mongo:latest

# at /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Compile the C++ application
RUN g++ -o src/build/webapi src/main.cpp

# Run webapi
CMD ["./src/build/webapi"]