set -e
set +v

DOCKER_DEPLOY="false"
if [[ "$TRAVIS_OS_NAME" = "linux" &&  ! "$DOCKER_USERNAME" = "" && ! "$DOCKER_PASSWORD" = "" && "$RECIPE" = "" ]]; then
    DOCKER_DEPLOY="true"
fi
if [[ "$DOCKER_DEPLOY" = "true" ]]; then
  docker login -p $DOCKER_PASSWORD -u $DOCKER_USERNAME
fi
export DOCKER_DEPLOY=$DOCKER_DEPLOY

ANACONDA_DEPLOY="false"
if [[ ! "$ANACONDA_USERNAME" = "" && ! "$ANACONDA_PASSWORD" = "" && ! "$RECIPE" = "" ]]; then
    ANACONDA_DEPLOY="true"
fi
if [[ "$ANACONDA_DEPLOY" = "true" ]]; then
  yes | anaconda login --password $ANACONDA_PASSWORD --username $ANACONDA_USERNAME
fi
export ANACONDA_DEPLOY=$ANACONDA_DEPLOY

set +ev