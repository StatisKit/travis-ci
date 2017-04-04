set -ev

if [[ ! "$RECIPE" = "" ]]; then
  if [[ "$TRAVIS_WAIT" = "true" ]]; then
    TRAVIS_WAIT=travis_wait
  elif [[ ! "$TRAVIS_WAIT" = "" ]]; then
    TRAVIS_WAIT="travis_wait $TRAVIS_WAIT"
  fi
  $TRAVIS_WAIT conda build ../conda/$RECIPE $ANACONDA_CHANNELS
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
