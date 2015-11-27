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
