set -ev

if [[ "$DOCKER_DEPLOY" = "true" ]]; then
  eval "docker push statiskit/"$DOCKERFILE":"$TRAVIS_TAG"-py"$CONDA_VERSION"k"
  if [[ ! "$TRAVIS_TAG" = "latest" ]]; then
    eval docker tag statiskit/"$DOCKERFILE":"$TRAVIS_TAG"-py"$CONDA_VERSION"k" statiskit/"$DOCKERFILE":latest-py"$CONDA_VERSION"k"
    eval "docker push statiskit/"$DOCKERFILE":latest-py"$CONDA_VERSION"k"
  fi
fi

if [[ "$ANACONDA_DEPLOY" = "true" ]]; then
  if [[ ! "$CONDA_RECIPE" = "" ]]; then
      anaconda upload `conda build --old-build-string --python=$PYTHON_VERSION ../$CONDA_RECIPE --output` -u $ANACONDA_UPLOAD --force --no-progress --label $ANACONDA_LABEL
  fi
fi

set +ev
