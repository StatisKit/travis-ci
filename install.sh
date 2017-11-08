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
  sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
  if [[ "$PLATFORM" = "x86" ]]; then
    sudo apt-get install ia32-libs
  fi
  sudo apt-get update
  sudo apt-get install -qq gcc-5 g++-5
  sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 60 --slave /usr/bin/g++ g++ /usr/bin/g++-5
  if [[ ! "$DOCKERFILE" = "" ]]; then
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt-get update
    sudo apt-get -y install docker-ce
  fi
  sudo apt-get install gfortran
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
