## Copyright [2017-2018] UMR MISTEA INRA, UMR LEPSE INRA,                ##
##                       UMR AGAP CIRAD, EPI Virtual Plants Inria        ##
##                                                                       ##
## This file is part of the StatisKit project. More information can be   ##
## found at                                                              ##
##                                                                       ##
##     http://autowig.rtfd.io                                            ##
##                                                                       ##
## The Apache Software Foundation (ASF) licenses this file to you under  ##
## the Apache License, Version 2.0 (the "License"); you may not use this ##
## file except in compliance with the License. You should have received  ##
## a copy of the Apache License, Version 2.0 along with this file; see   ##
## the file LICENSE. If not, you may obtain a copy of the License at     ##
##                                                                       ##
##     http://www.apache.org/licenses/LICENSE-2.0                        ##
##                                                                       ##
## Unless required by applicable law or agreed to in writing, software   ##
## distributed under the License is distributed on an "AS IS" BASIS,     ##
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or       ##
## mplied. See the License for the specific language governing           ##
## permissions and limitations under the License.                        ##

set -ev

# export CONDA_PIN=4.3.30
# export CONDA_BUILD_PIN=3.0.30
# export ANACONDA_CLIENT_PIN=1.6.5

source tools.sh

if [[ "$CI" = "false" ]]; then
  git submodule update --init
fi

if [[ "$TRAVIS_OS_NAME" = "" ]]; then
  if [ "$(uname)" == "Darwin" ]; then
    export TRAVIS_OS_NAME="osx"
  elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    export TRAVIS_OS_NAME="linux"
  else
    echo "Invalid OS name for this install script"
    exit 1
  fi
fi

if [[ "$ARCH" = "" ]]; then
  export ARCH=x86_64
fi

if [[ "$CONDA_VERSION" = "" ]]; then
  export CONDA_VERSION=2
fi

if [[ ! "$ANACONDA_LOGIN" = "" ]]; then
  if [[ "$ANACONDA_OWNER" = "" ]]; then
    export ANACONDA_OWNER=$ANACONDA_LOGIN
  fi
fi

if [[ "$ANACONDA_DEPLOY" = "" ]]; then
    if [[ ! "$ANACONDA_LOGIN" = "" ]]; then
        export ANACONDA_DEPLOY=true
    else
        export ANACONDA_DEPLOY=false
    fi
fi

if [[ "$ANACONDA_RELEASE" = "" ]]; then
    export ANACONDA_RELEASE=false
fi

if [[ "$ANACONDA_LABEL" = "" ]]; then
    export ANACONDA_LABEL=main
fi

if [[ ! "$DOCKER_LOGIN" = "" ]]; then
  if [[ "$DOCKER_OWNER" = "" ]]; then
    export DOCKER_OWNER=$DOCKER_LOGIN
  fi
fi

if [[ "$DOCKER_DEPLOY" = "" ]]; then
    if [[ ! "$DOCKER_LOGIN" = "" && "$TRAVIS_OS_NAME" = "linux" ]]; then
        export DOCKER_DEPLOY=true
    else
        export DOCKER_DEPLOY=false
    fi
fi

if [[ ! "$DOCKER_CONTEXT" = "" ]]; then
  if [[ "$DOCKER_CONTAINER" = "" ]]; then
    export DOCKER_CONTAINER=`basename $DOCKER_CONTEXT`
  fi
  if [[ "$CI" = "true" ]]; then
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt-get update
    sudo apt-get -y install docker-ce 
  fi
fi

if [[ "$TRAVIS_TAG" = "" ]]; then
  export TRAVIS_TAG="latest"
fi

if [[ "$JUPYTER_KERNEL" = "" ]]; then
  export JUPYTER_KERNEL='python'$CONDA_VERSION 
fi


if [[ "$CI" = "true" ]]; then
  if [[ "$TRAVIS_WAIT" = "true" ]]; then
    export TRAVIS_WAIT=travis_wait
  elif [[ ! "$TRAVIS_WAIT" = "" ]]; then
    export TRAVIS_WAIT="travis_wait $TRAVIS_WAIT"
  fi
else
  export TRAVIS_WAIT=
fi

if [[ "$CONDA_PREFIX" = "" || ! -d "$CONDA_PREFIX" ]]; then
  if [[ "$TRAVIS_OS_NAME" = "linux" ]]; then
    curl https://repo.continuum.io/miniconda/Miniconda${CONDA_VERSION}-latest-Linux-${ARCH}.sh -o miniconda.sh
  else
    curl https://repo.continuum.io/miniconda/Miniconda${CONDA_VERSION}-latest-MacOSX-x86_64.sh -o miniconda.sh
  fi

  chmod a+rwx miniconda.sh
  set +v
  if [[ "$CONDA_PREFIX" = "" ]]; then
    ./miniconda.sh -b -p $HOME/miniconda
  else
    ./miniconda.sh -b -p $CONDA_PREFIX
  fi
  set -v
  rm miniconda.sh
fi
if [[ "$CONDA_PREFIX" = "" ]]; then
  export PATH=$HOME/miniconda/bin:$PATH
else
  export PATH=$CONDA_PREFIX/bin:$PATH
fi

set +v
source activate
set -v
if [[ ! "$ANACONDA_CHANNELS" = "" ]]; then
  conda config --add channels $ANACONDA_CHANNELS
fi
conda config --set always_yes yes
conda config --set remote_read_timeout_secs 600
conda config --set auto_update_conda False

if [[ ! "$CONDA_PIN" = "" ]]; then
    conda install conda=$CONDA_PIN
fi
if [[ ! "$CONDA_BUILD_PIN" = "" ]]; then
    conda install conda-build=$CONDA_BUILD_PIN
else
    conda install conda-build
fi
set +v
source activate
set -v
source config.sh

if [[ "$CI" = "true" ]]; then
  conda install requests
  python release.py
fi

if [[ "$CI" = "false" ]]; then
    conda create -n py${CONDA_VERSION}k python=$CONDA_VERSION
    set +v
    source activate py${CONDA_VERSION}k
    set -v
fi
if [[ ! "$ANACONDA_CLIENT_PIN" = "" ]]; then
    conda install anaconda-client=$ANACONDA_CLIENT_PIN
else
    conda install anaconda-client
fi
export PYTHON_VERSION=`python -c "import sys; print(str(sys.version_info.major) + '.' + str(sys.version_info.minor))"`

if [[ ! "$CONDA_PACKAGES" = "" ]]; then
    if [[ "$CI" = "true" ]]; then
        conda install $CONDA_PACKAGES --use-local
        set +v
        source activate
        set -v
    else
        conda install -n py${CONDA_VERSION}k $CONDA_PACKAGES --use-local
        set +v
        source activate py${CONDA_VERSION}k
        set -v
    fi
fi

source post_config.sh

set +ev
