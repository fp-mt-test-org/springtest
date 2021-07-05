## Install Dependencies

    ./flex.sh

## Build

    flex build

## Running Locally w/ Docker

After a successful build, you can run it like so:

    docker run -p 8080:8080 springtest:0.0.13-SNAPSHOT

After it starts successfully, you can get a successfully http response:

    curl localhost:8080/actuator/health
    {"status":"UP"}

## Running w/ Kubernetes

    flex deploy
