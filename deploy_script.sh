set -ev

if [[ "$DOCKER_DEPLOY" = "true" ]]; then
  docker push statiskit/$DOCKERFILE
fi

if [[ "$ANACONDA_DEPLOY" = "true" ]]; then
  if [[ "$TRAVIS_OS_NAME" = "linux" ]]; then		
    if [[ ! "$ENVIRONMENT" = "" ]]; then		
      anaconda upload ../environment.yml -u $ANACONDA_UPLOAD --force		
    fi
  fi
  if [[ ! "$RECIPE" = "" ]]; then
      anaconda upload `conda build ../conda/$RECIPE $ANACONDA_CHANNELS --output` -u $ANACONDA_UPLOAD --force
  fi
fi

set +ev
