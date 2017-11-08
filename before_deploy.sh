set -e
set +v

if [[ "$DOCKER_DEPLOY" = "true" ]]; then
  docker login -p $DOCKER_PASSWORD -u $DOCKER_USERNAME
fi

if [[ "$ANACONDA_DEPLOY" = "true" ]]; then
  yes | anaconda login --password $ANACONDA_PASSWORD --username $ANACONDA_USERNAME
fi

set +ev
