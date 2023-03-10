FROM andrescabana86/libboost-base:latest
# at /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Compile the C++ application
RUN g++ -o webapi src/main.cpp

# Set the command to run the executable
CMD ["./webapi"]