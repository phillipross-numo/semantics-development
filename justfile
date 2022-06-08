
export PREFIX := env_var_or_default('PREFIX','llsem-')
export UBUNTU_TAG := env_var_or_default('UBUNTU_TAG','jammy-20220531')

all: build-ubuntu build-zulu build-maven build-jena build-blazegraph

build-ubuntu:
   time docker image build --pull -f Dockerfile.ubuntu -t ${PREFIX}ubuntu:latest --build-arg PARENT_TAG=${UBUNTU_TAG} .

build-zulu: build-zulu-8 build-zulu-11 build-zulu-17

build-zulu-8: build-ubuntu
   time docker image build -f Dockerfile.ubuntu-zulu  -t ${PREFIX}ubuntu-zulu:8  --build-arg PREFIX=${PREFIX} --build-arg JAVA_VER_DISTRO=8.0.332-zulu  .
  
build-zulu-11: build-ubuntu
   time docker image build -f Dockerfile.ubuntu-zulu  -t ${PREFIX}ubuntu-zulu:11  --build-arg PREFIX=${PREFIX} --build-arg JAVA_VER_DISTRO=11.0.15-zulu  .
  
build-zulu-17: build-ubuntu
   time docker image build -f Dockerfile.ubuntu-zulu  -t ${PREFIX}ubuntu-zulu:17  --build-arg PREFIX=${PREFIX} --build-arg JAVA_VER_DISTRO=17.0.3-zulu  .

build-kotlin: build-kotlin-8 build-kotlin-11 build-kotlin-17

build-kotlin-8: build-zulu-8
   time docker image build -f Dockerfile.ubuntu-kotlin -t ${PREFIX}ubuntu-kotlin:8 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=8 .

build-kotlin-11: build-zulu-11
   time docker image build -f Dockerfile.ubuntu-kotlin -t ${PREFIX}ubuntu-kotlin:11 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=11 .

build-kotlin-17: build-zulu-17
   time docker image build -f Dockerfile.ubuntu-kotlin -t ${PREFIX}ubuntu-kotlin:17 --build-arg PREFIX=${PREFIX} --build-arg PARENT_TAG=17 .

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
