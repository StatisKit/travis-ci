set -ev

if [[ "$DOCKER_DEPLOY" = "true" ]]; then
  docker push statiskit/$DOCKERFILE:$CONDA_VERSION
fi

if [[ "$ANACONDA_DEPLOY" = "true" ]]; then
  if [[ "$TRAVIS_OS_NAME" = "linux" ]]; then		
    if [[ ! "$CONDA_ENVIRONMENT" = "" ]]; then		
      anaconda upload ../environment.yml -u $ANACONDA_UPLOAD --force		
    fi
  fi
  if [[ ! "$CONDA_RECIPE" = "" ]]; then
      anaconda upload `conda build ../bin/conda/$CONDA_RECIPE $ANACONDA_CHANNELS --output` -u $ANACONDA_UPLOAD --force --no-progress
  fi
fi

set +ev
