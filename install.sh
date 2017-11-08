set -ev

if [[ "$CONDA_VERSION" = "" ]]; then
  export CONDA_VERSION=2
fi

if [[ ! "$ANACONDA_USERNAME" = "" ]]; then
  if [[ "$ANACONDA_UPLOAD" = "" ]]; then
    export ANACONDA_UPLOAD=$ANACONDA_USERNAME
  fi
fi

if [[ "$ANACONDA_DEPLOY" = "" ]]; then
    if [[ ! "$ANACONDA_USERNAME" = "" ]]; then
        export ANACONDA_DEPLOY=true
    else
        export ANACONDA_DEPLOY=false
    fi
fi

if [[ "$ANACONDA_LABEL" = "" ]]; then
    export ANACONDA_LABEL=main
fi

if [[ ! "$DOCKER_USERNAME" = "" ]]; then
  if [[ "$DOCKER_UPLOAD" = "" ]]; then
    export DOCKER_UPLOAD=$DOCKER_USERNAME
  fi
fi

if [[ "$DOCKER_DEPLOY" = "" ]]; then
    if [[ ! "$DOCKER_USERNAME" = "" && "$TRAVIS_OS_NAME" = "linux" ]]; then
        export DOCKER_DEPLOY=true
    else
        export DOCKER_DEPLOY=false
    fi
fi

if [[ ! "$DOCKERFILE" = "" ]]; then
  if [[ "$DOCKER_REPOSITORY" = "" ]]; then
    export DOCKER_REPOSITORY=`basename $(dirname ..\$DOCKERFILE)`
  fi
fi

if [[ "$TRAVIS_TAG" = "" ]]; then
  export TRAVIS_TAG="latest"
fi

if [[ "$TRAVIS_WAIT" = "true" ]]; then
  TRAVIS_WAIT=travis_wait
elif [[ ! "$TRAVIS_WAIT" = "" ]]; then
  TRAVIS_WAIT="travis_wait $TRAVIS_WAIT"
fi

if [[ "$TRAVIS_OS_NAME" = "linux" ]]; then
  curl "https://repo.continuum.io/miniconda/Miniconda"$CONDA_VERSION"-latest-Linux-x86_64.sh" -o miniconda.sh
else
  curl "https://repo.continuum.io/miniconda/Miniconda"$CONDA_VERSION"-latest-MacOSX-x86_64.sh" -o miniconda.sh
fi

chmod a+rwx miniconda.sh
./miniconda.sh -b -p $HOME/miniconda
rm miniconda.sh
export PATH=$HOME/miniconda/bin:$PATH
source activate root
if [[ ! "$ANACONDA_CHANNELS" = "" ]]; then
  conda config --add channels $ANACONDA_CHANNELS
fi
source config.sh

conda update conda
conda install conda-build anaconda-client

export PYTHON_VERSION=`python -c "import sys; print(str(sys.version_info.major) + str(sys.version_info.minor))"`

set +ev
