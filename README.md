RSS Recipes
===========

[![Build Status](https://travis-ci.org/jojow/netflix-rss-app.svg)](https://travis-ci.org/jojow/netflix-rss-app)

RSS is a Netflix Recipes application demonstrating how Netflix Open Source components can be tied together.

This is a modified version of the RSS Recipes to make it suitable for deploying on [Kubernetes](http://kubernetes.io/).
For information regarding the original application by Netflix, please visit https://github.com/Netflix/recipes-rss.


Modifications
=============

* Eureka is not used in this setup as Kubernetes provides [Services](http://kubernetes.io/v1.0/docs/user-guide/services.html) which is an abstraction layer for service discovery and load balancing. Edge and middletier are configured to use this feature.
* Middletier is configured to use cassandra by default
* Edge and middletier are packaged as standalone jar files
* Edge returns 500 to user if an error occurred internally
* Version number and hostnames of edge and middletier are shown on the page for debugging purpose
* Added multi-user support
* Added healthcheck page
* Upgraded netty to 4.0.26.Final
* Upgraded jersey to 1.19
