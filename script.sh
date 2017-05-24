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
elif [[ ! "$DOCKERFILE" = "" ]]; then
  mv ../docker/$DOCKERFILE ../docker/Dockerfile
  docker build -t statiskit/$DOCKERFILE ../docker
  mv ../docker/Dockerfile ../docker/$DOCKERFILE
fi

set +ev
