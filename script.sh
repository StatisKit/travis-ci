set -ev

if [[ ! "$RECIPE" = "" ]]; then
  conda build ../conda/$RECIPE -c conda-forge -c statiskit
elif [[ ! "$UBUNTU" = "" ]]; then
  docker pull ubuntu:$UBUNTU
  docker tag ubuntu:$UBUNTU statiskit/ubuntu
  docker build -t statiskit/ubuntu:$UBUNTU ../docker/ubuntu
fi

set +ev