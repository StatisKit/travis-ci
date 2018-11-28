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
## Unless required by applicable law or agreed to in writing, software   ##`
## distributed under the License is distributed on an "AS IS" BASIS,     ##
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or       ##
## mplied. See the License for the specific language governing           ##
## permissions and limitations under the License.                        ##

set -ve

if [[ "${CI}" = "false" ]]; then
  git submodule update --init
else
  source travis_wait.sh
  if [[ ! "${DOCKER_CONTEXT}" = "" ]]; then
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt-get update
    sudo apt-get -y install docker-ce 
  fi
fi

if [[ "${TRAVIS_OS_NAME}" = "windows" ]]; then
  cmd "/C /K echo %CONDA_PREFIX%"
fi

if [[ ! -d "${CONDA_PREFIX}" ]]; then
  if [[ "${TRAVIS_OS_NAME}" = "linux" ]]; then
    curl https://repo.continuum.io/miniconda/Miniconda${CONDA_VERSION}-latest-Linux-${ARCH}.sh -o miniconda.sh
  elif [[ "${TRAVIS_OS_NAME}" = "osx" ]]; then
    curl https://repo.continuum.io/miniconda/Miniconda${CONDA_VERSION}-latest-MacOSX-${ARCH}.sh -o miniconda.sh
  else
    curl https://repo.continuum.io/miniconda/Miniconda${CONDA_VERSION}-latest-Windows-${ARCH}.exe -o miniconda.exe
  fi
  if [[ ! "${TRAVIS_OS_NAME}" = "windows" ]]; then
    chmod a+rwx miniconda.sh
    set +v
    ./miniconda.sh -b -p ${CONDA_PREFIX}
    set -v
    rm miniconda.sh
  else
    cmd "/C miniconda.exe  /AddToPath=1 /InstallationType=JustMe /RegisterPython=0 /S /D=%HOMEDRIVE%\Miniconda"
    rm miniconda.exe
  fi
fi

if [[ ! "${TRAVIS_OS_NAME}" = "linux" ]]; then
    export PATH=${CONDA_PREFIX}/bin:${PATH}
fi

if [[ "${TRAVIS_OS_NAME}" = "linux" ]]; then
  echo ". ${CONDA_PREFIX}/etc/profile.d/conda.sh" >> ${HOME}/.bashrc
  set +v
  source ${HOME}/.bashrc
  set -v
else
  echo ". ${CONDA_PREFIX}/etc/profile.d/conda.sh" >> ${HOME}/.bash_profile
  set +v
  source ${HOME}/.bash_profile
  set -v
fi
conda activate

if [[ ! "${ANACONDA_CHANNELS}" = "" ]]; then
  conda config ${ANACONDA_CHANNELS}
fi
conda config --set always_yes yes
conda config --set remote_read_timeout_secs 600
conda config --set auto_update_conda False

if [[ ! "${CONDA_PIN}" = "" ]]; then
    conda install conda=${CONDA_PIN}
fi
if [[ ! "${CONDA_BUILD_PIN}" = "" ]]; then
    conda install conda-build=${CONDA_BUILD_PIN}
else
    conda install conda-build
fi

if [[ "${CI}" = "true" ]]; then
  conda install requests
  python release.py
  if [[ ! "$?" = "0" ]]; then
    exit 1
  fi
fi

if [[ ! "${ANACONDA_CLIENT_PIN}" = "" ]]; then
    conda install anaconda-client=${ANACONDA_CLIENT_PIN}
else
    conda install anaconda-client
fi
anaconda config --set auto_register yes

conda create -n travis-ci python=${PYTHON_VERSION}

if [[ ! "${CONDA_PACKAGES}" = "" ]]; then
    conda install -n travis-ci ${CONDA_PACKAGES} --use-local
fi

conda activate travis-ci

set +ve