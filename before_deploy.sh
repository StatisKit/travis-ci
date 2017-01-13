set -e
set +v

DOCKER_DEPLOY="false"
if [[ "$TRAVIS_OS_NAME" = "linux" && -z $DOCKER_USERNAME && -z $DOCKER_PASSWORD ]]; then
    DOCKER_DEPLOY="true"
fi
if [[ "$DOCKER_DEPLOY" = "true" ]]; then
  docker login -p $DOCKER_PASSWORD -u $DOCKER_USERNAME
fi

ANACONDA_DEPLOY="false"
if [[ -z ANACONDA_USERNAME && -z ANACONDA_PASSWORD && -z RECIPE ]]; then
    ANACONDA_DEPLOY="true"
fi
if [[ "$ANACONDA_DEPLOY" = "true" ]]; then
  anaconda login --password $ANACONDA_PASSWORD --username $ANACONDA_USERNAME
fi

set +ev