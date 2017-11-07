set -e
set +v

if [[ "$DOCKER_DEPLOY" = "" ]]; then
    if [[ "$TRAVIS_OS_NAME" = "linux" &&  ! "$DOCKER_USERNAME" = "" && ! "$DOCKER_PASSWORD" = "" && "$CONDA_RECIPE" = "" && "$CONDA_ENVIRONMENT" = "" ]]; then
        export DOCKER_DEPLOY="true"
    else
        export DOCKER_DEPLOY="false"
    fi
fi
if [[ "$DOCKER_DEPLOY" = "true" ]]; then
  docker login -p $DOCKER_PASSWORD -u $DOCKER_USERNAME
fi

if [[ "$ANACONDA_DEPLOY" = "" ]]; then
    if [[ ! "$ANACONDA_USERNAME" = "" && ! "$ANACONDA_PASSWORD" = "" ]]; then
        if [[ ! "$CONDA_RECIPE" = "" || ! "$CONDA_ENVIRONMENT" = "" ]]; then
            export ANACONDA_DEPLOY="true"
        else
            export ANACONDA_DEPLOY="false"
        fi
    else
        export ANACONDA_DEPLOY="false"
    fi
fi
if [[ "$ANACONDA_DEPLOY" = "true" ]]; then
  yes | anaconda login --password $ANACONDA_PASSWORD --username $ANACONDA_USERNAME
fi

set +ev
