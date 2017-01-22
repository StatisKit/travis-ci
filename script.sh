set -ev

if [[ ! "$RECIPE" = "" ]]; then
  conda build ../conda/$RECIPE -c conda-forge -c statiskit
elif [[ ! "$ENVIRONMENT" = "" ]]; then
  conda env update -f ../$ENVIRONMENT
elif [[ ! "$UBUNTU" = "" ]]; then
  docker pull ubuntu:$UBUNTU
  docker tag ubuntu:$UBUNTU statiskit/ubuntu
  mv ../docker/ubuntu ../docker/Dockerfile
  docker build -t statiskit/ubuntu:$UBUNTU ../docker
  mv ../docker/Dockerfile ../docker/ubuntu
fi

set +ev
