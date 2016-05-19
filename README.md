# RSS Recipes

[![Build Status](https://travis-ci.org/jojow/netflix-rss-app.svg)](https://travis-ci.org/jojow/netflix-rss-app)

RSS is a Netflix Recipes application demonstrating how Netflix Open Source components can be tied together.
See: https://github.com/Netflix/recipes-rss

This is a modified version of the application, which is suitable for deployment using [Kubernetes](http://kubernetes.io).
See: https://github.com/hora-prediction/recipes-rss-kube

The goal of this repository is to demonstrate how **continuous integration and delivery** can be implemented for the application based on Travis and Docker Hub.



## Pipeline setup

The currently implemented pipeline is structured as follows:

![Pipeline overview](/pipeline-docs/pipeline-overview.png)

In its current setup, the pipeline relies on three services: GitHub, Travis CI, and Docker Hub.
All these services are free to use if you use them in conjunction with public repositories.
If you would like to create your own instance of the pipeline, please follow these steps:

* Create your personal accounts on GitHub, Travis CI, and Docker Hub (if you don't have already).
* [Fork](https://github.com/jojow/netflix-rss-app/fork) this repository to get your own clone.
* Sync your GitHub account with your Travis account and enable the newly forked repository in Travis.
* Configure the Travis build by setting the environment variables as shown in the following screenshot.
* The DOCKER variables represent your Docker Hub credentials to push container images later on; therefore they should be encrypted!
* The IMAGE variables are used to define the name of the container images pushed to Docker Hub; these must be usually prefixed with your username.
* Now you can commit changes to the repository and see the pipeline running. :-)



## Travis settings

![Travis settings](/pipeline-docs/travis-settings.png)



## Snap settings

Alternatively to Travis CI, you can use Snap CI to build and run the pipeline.
However, you need to configure the pipeline manually because Snap CI does not support pipeline as code (yet).
Use the following settings:

![Snap settings](/pipeline-docs/snap-settings.png)

The stages need to be configured as follows:

### Unit test

Commands:

    ./gradlew --quiet clean test

### Build

Commands:

    sed -i -e "s/.*version.*/version=current/" gradle.properties
    ./gradlew --quiet clean build
    sudo docker build -f Dockerfile_middletier -t "$RSS_MIDDLETIER_IMAGE:built" .
    sudo docker build -f Dockerfile_edge -t "$RSS_EDGE_IMAGE:built" .
    sudo docker login -e "$DOCKER_EMAIL" -u "$DOCKER_USERNAME" -p "$DOCKER_PASSWORD"
    sudo docker push "$RSS_MIDDLETIER_IMAGE:built"
    sudo docker push "$RSS_EDGE_IMAGE:built"

Environment variables:

* RSS_MIDDLETIER_IMAGE = johannesw/netflix-rss-middletier
* RSS_EDGE_IMAGE = johannesw/netflix-rss-edge
* DOCKER_EMAIL = ******
* DOCKER_USERNAME = ******
* DOCKER_PASSWORD = ******

Artifacts:

* ./rss-middletier/build/libs/rss-middletier-current.jar
* ./rss-edge/build/libs/rss-edge-current.jar

### Integration test

Commands:

    echo "built" > tag
    sudo -E ./test/smoketest.sh

Environment variables:

* RSS_MIDDLETIER_IMAGE = johannesw/netflix-rss-middletier
* RSS_EDGE_IMAGE = johannesw/netflix-rss-edge

### Publish

Commands:

    sudo docker pull "$RSS_MIDDLETIER_IMAGE:built"
    sudo docker pull "$RSS_EDGE_IMAGE:built"
    sudo docker tag -f "$RSS_MIDDLETIER_IMAGE:built" "$RSS_MIDDLETIER_IMAGE:latest"
    sudo docker tag -f "$RSS_EDGE_IMAGE:built" "$RSS_EDGE_IMAGE:latest"
    sudo docker save -o ./rss-middletier-latest.docker.tar "$RSS_MIDDLETIER_IMAGE:latest"
    sudo docker save -o ./rss-edge-latest.docker.tar "$RSS_EDGE_IMAGE:latest"
    sudo docker login -e "$DOCKER_EMAIL" -u "$DOCKER_USERNAME" -p "$DOCKER_PASSWORD"
    sudo docker push "$RSS_MIDDLETIER_IMAGE:latest"
    sudo docker push "$RSS_EDGE_IMAGE:latest"

Environment variables:

* RSS_MIDDLETIER_IMAGE = johannesw/netflix-rss-middletier
* RSS_EDGE_IMAGE = johannesw/netflix-rss-edge
* DOCKER_EMAIL = ******
* DOCKER_USERNAME = ******
* DOCKER_PASSWORD = ******

Artifacts:

* ./rss-middletier-latest.docker.tar
* ./rss-edge-latest.docker.tar
