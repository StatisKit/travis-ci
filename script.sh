set -ev

if [[ ! "$CONDA_RECIPE" = "" ]]; then
  if [[ "$TRAVIS_WAIT" = "true" ]]; then
    TRAVIS_WAIT=travis_wait
  elif [[ ! "$TRAVIS_WAIT" = "" ]]; then
    TRAVIS_WAIT="travis_wait $TRAVIS_WAIT"
  fi
  $TRAVIS_WAIT conda build ../bin/conda/$CONDA_RECIPE $ANACONDA_CHANNELS
elif [[ ! "$JUPYTER_NOTEBOOK" = "" ]]; then
  jupyter nbconvert --ExecutePreprocessor.timeout=3600 --to notebook --execute ../share/jupyter/$JUPYTER_NOTEBOOK --output ../share/jupyter/$JUPYTER_NOTEBOOK
elif [[ ! "$DOCKERFILE" = "" ]]; then
  mv ../bin/docker/$DOCKERFILE ../bin/docker/Dockerfile
  docker build -t statiskit/$DOCKERFILE ../docker
  mv ../bin/docker/Dockerfile ../bin/docker/$DOCKERFILE
fi

set +ev
