set -ev

if [[ "$TRAVIS_WAIT" = "true" ]]; then
  TRAVIS_WAIT=travis_wait
elif [[ ! "$TRAVIS_WAIT" = "" ]]; then
  TRAVIS_WAIT="travis_wait $TRAVIS_WAIT"
fi
  
if [[ ! "$CONDA_RECIPE" = "" ]]; then
  cd ../bin/conda
  $TRAVIS_WAIT conda build --python=$PYTHON_VERSION $CONDA_RECIPE $ANACONDA_CHANNELS
  cd ../../travis-ci
elif [[ ! "$JUPYTER_NOTEBOOK" = "" ]]; then
  cd ../share/jupyter
  $TRAVIS_WAIT jupyter nbconvert --ExecutePreprocessor.kernel_name='python'$CONDA_VERSION --ExecutePreprocessor.timeout=3600 --to notebook --execute $JUPYTER_NOTEBOOK --output $JUPYTER_NOTEBOOK
  cd ../../travis-ci
elif [[ ! "$DOCKERFILE" = "" ]]; then
  cd ../bin/docker
  mv $DOCKERFILE Dockerfile
  $TRAVIS_WAIT docker build --build-arg CONDA_VERSION=$CONDA_VERSION -t statiskit/$DOCKERFILE:latest-$PYTHON_VERSION .
  mv Dockerfile $DOCKERFILE
  cd ../../travis-ci
fi

set +ev
