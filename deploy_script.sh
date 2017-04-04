set -ev

if [[ "$DOCKER_DEPLOY" = "true" ]]; then
  docker push statiskit/ubuntu:$UBUNTU
fi

if [[ "$ANACONDA_DEPLOY" = "true" ]]; then
  if [[ "$TRAVIS_OS_NAME" = "linux" ]]; then
    if [[ ! "$ENVIRONMENT" = "" ]]; then
      mv ../$ENVIRONMENT environment.yml
      anaconda upload environment.yml -u statiskit --force
      mv environment.yml ../$ENVIRONMENT
    fi
    #md5sum `conda build ../conda/$RECIPE -c conda-forge -c statiskit --output`
  fi
  if [[ ! "$RECIPE" = "" ]]; then
    if [[ "$ANACONDA_OFFICIAL" = "true" ]]; then
      anaconda upload `conda build ../conda/$RECIPE -c statiskit -c conda-forge --output` -u statiskit --force
    else
      anaconda upload `conda build ../conda/$RECIPE -c statiskit -c conda-forge --output` -u $ANACONDA_USERNAME --force    
    fi
  fi
fi

set +ev
