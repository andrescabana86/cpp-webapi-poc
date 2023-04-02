# C++ Web API POC

## Docker images
Docker folder has all images I created for the project. The idea was to create images 
I could share using docker hub.
### List of images
* libboost-mongo.Dockerfile is main image, based on Ubuntu and contains all tooling set.
### How to?
* Development mode: run 

## Development vs Production
For the purpose of learning how to run a local C++ api without depending on docker, I created a docker file with all dependencies but I'm also managing local dependencies outside of docker. This way, I can run database from docker, but C++ API without docker.
### Advantages
* Docker is prod only
* Database does not depend on local installation
* C++ API can be modify without running docker
* Development speed increases b/c there is no need to run docker