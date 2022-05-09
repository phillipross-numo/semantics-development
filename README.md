# Luminosity Labs Semantics

This project collects various opensource tools together in a single location to provide a toolset for developing semantic web applications.

---
## Included

- A collection of Dockerfiles for customized builds of Ubuntu Linux, Zulu OpenJDK, Apache Jena, and Blazegraph

## Getting started

### Requirements

- Docker Desktop
- [just] (https://github.com/casey/just)

### Building Docker images

The justfile located in the root directory of the project contains targets for building the Docker images.  Since some
  of the images are interdependent, the justfile contains the dependency rules for building the dependent images in
  dependency order.

To build all images, simple type `just` or `just all`

To get list of the buildable images, type `just --list` to get a list of builds recipes.

To build a specific image, type the name of the build recipe correpsonding to the image to build (ex: `just build-blazegraph`)



