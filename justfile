#!/usr/bin/env just --justfile

export PREFIX := env_var_or_default('PREFIX','llsem-')
export UBUNTU_TAG := env_var_or_default('UBUNTU_TAG','jammy-20220801')
export JAVA_VER_DISTRO_8 := "8.0.345-zulu"
export JAVA_VER_DISTRO_11 := "11.0.16-zulu"
export JAVA_VER_DISTRO_17 := "17.0.4-zulu"
export KOTLIN_VER := "1.7.10"
export KSCRIPT_VER := "4.1.0"

all: build-ubuntu build-zulu build-maven build-jena build-blazegraph

build-ubuntu:
   time docker image build --pull -f Dockerfile.ubuntu -t ${PREFIX}ubuntu:latest --build-arg PARENT_TAG=${UBUNTU_TAG} .

build-zulu: build-zulu-8 build-zulu-11 build-zulu-17

build-zulu-8: build-ubuntu
   time docker image build -f Dockerfile.ubuntu-zulu  -t ${PREFIX}ubuntu-zulu:8  --build-arg PREFIX=${PREFIX} --build-arg JAVA_VER_DISTRO=${JAVA_VER_DISTRO_8}  .
  
build-zulu-11: build-ubuntu
   time docker image build -f Dockerfile.ubuntu-zulu  -t ${PREFIX}ubuntu-zulu:11  --build-arg PREFIX=${PREFIX} --build-arg JAVA_VER_DISTRO=${JAVA_VER_DISTRO_11}  .
  
build-zulu-17: build-ubuntu
   time docker image build -f Dockerfile.ubuntu-zulu  -t ${PREFIX}ubuntu-zulu:17  --build-arg PREFIX=${PREFIX} --build-arg JAVA_VER_DISTRO=${JAVA_VER_DISTRO_17}  .

build-kotlin: build-kotlin-8 build-kotlin-11 build-kotlin-17

build-kotlin-8: build-zulu-8
   time docker image build -f Dockerfile.ubuntu-kotlin -t ${PREFIX}ubuntu-kotlin:8 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=8 --build-arg KOTLIN_VER=${KOTLIN_VER} --build-arg KSCRIPT_VER=${KSCRIPT_VER} .

build-kotlin-11: build-zulu-11
   time docker image build -f Dockerfile.ubuntu-kotlin -t ${PREFIX}ubuntu-kotlin:11 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=11 --build-arg KOTLIN_VER=${KOTLIN_VER} --build-arg KSCRIPT_VER=${KSCRIPT_VER} .

build-kotlin-17: build-zulu-17
   time docker image build -f Dockerfile.ubuntu-kotlin -t ${PREFIX}ubuntu-kotlin:17 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=17 --build-arg KOTLIN_VER=${KOTLIN_VER} --build-arg KSCRIPT_VER=${KSCRIPT_VER} .

build-maven: build-maven-8 build-maven-11 build-maven-17

build-maven-8: build-kotlin-8
   time docker image build -f Dockerfile.ubuntu-maven -t ${PREFIX}ubuntu-maven:8 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=8 .

build-maven-11: build-kotlin-11
   time docker image build -f Dockerfile.ubuntu-maven -t ${PREFIX}ubuntu-maven:11 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=11 .

build-maven-17: build-kotlin-17
   time docker image build -f Dockerfile.ubuntu-maven -t ${PREFIX}ubuntu-maven:17 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=17 .

build-jena: build-jena-11 build-jena-17

build-jena-11: build-maven-11
   time docker image build -f Dockerfile.ubuntu-jena -t ${PREFIX}ubuntu-jena:11 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=11 .

build-jena-17: build-maven-17
   time docker image build -f Dockerfile.ubuntu-jena -t ${PREFIX}ubuntu-jena:17 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=17 .

build-blazegraph: build-maven-8
   time docker image build -f Dockerfile.ubuntu-blazegraph -t ${PREFIX}ubuntu-blazegraph:latest --build-arg PREFIX=${PREFIX} .

list-dockerhub-ubuntu-tags:
   curl -Ls 'https://registry.hub.docker.com/v2/repositories/library/ubuntu/tags?page_size=1024'|jq '."results"[]["name"]' | grep jammy

list-jena-upstream-main-commit-id:
   git ls-remote https://github.com/apache/jena heads/main

list-jena-upstream-main-pom-version:
   curl -Ls https://raw.githubusercontent.com/apache/jena/main/pom.xml |sed -e 's/xmlns="[^"]*"//g' | xmllint --xpath '/project/version/text()' -