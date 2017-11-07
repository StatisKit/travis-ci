set -ev
  
if [[ ! "$CONDA_RECIPE" = "" ]]; then
  $TRAVIS_WAIT conda build --old-build-string --no-locking --python=$PYTHON_VERSION ../$CONDA_RECIPE
elif [[ ! "$JUPYTER_NOTEBOOK" = "" ]]; then
  $TRAVIS_WAIT jupyter nbconvert --ExecutePreprocessor.kernel_name='python'$CONDA_VERSION --ExecutePreprocessor.timeout=0 --to notebook --execute ../$JUPYTER_NOTEBOOK --output ../$JUPYTER_NOTEBOOK
elif [[ ! "$DOCKERFILE" = "" ]]; then
  mv ../$DOCKERFILE Dockerfile
  eval $TRAVIS_WAIT" docker build --build-arg CONDA_VERSION=$CONDA_VERSION -t $DOCKER_UPLOAD/"$DOCKER_REPOSITORY":"$TRAVIS_TAG"-py"$CONDA_VERSION"k ."
  mv Dockerfile ../$DOCKERFILE
fi

set +ev
