set -ev

if [[ "$DOCKER_DEPLOY" = "true" ]]; then
  docker push statiskit/$DOCKERFILE
fi

if [[ "$ANACONDA_DEPLOY" = "true" ]]; then
  if [[ ! "$RECIPE" = "" ]]; then
      anaconda upload `conda build ../conda/$RECIPE $ANACONDA_CHANNELS --output` -u $ANACONDA_UPLOAD --force
  fi
fi

set +ev
