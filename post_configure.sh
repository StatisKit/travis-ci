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

if [[ ! -d "${CONDA_PREFIX}" || "${TRAVIS_OS_NAME}" = "windows" ]]; then
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
    cmd "/C miniconda.exe /AddToPath=1 /InstallationType=JustMe /RegisterPython=0 /S /D=%HOMEDRIVE%\Miniconda > C:\log.txt"
    cat /c/log.txt
    rm miniconda.exe
  fi
fi

if [[ "${TRAVIS_OS_NAME}" = "linux" ]]; then
  echo ". ${CONDA_PREFIX}/etc/profile.d/conda.sh" >> ${HOME}/.bashrc
  set +v
  source ${HOME}/.bashrc
  set -v
elif [[ "${TRAVIS_OS_NAME}" = "osx" ]]; then
  echo ". ${CONDA_PREFIX}/etc/profile.d/conda.sh" >> ${HOME}/.bash_profile
  set +v
  source ${HOME}/.bash_profile
  set -v
else
  export PATH=${CONDA_PREFIX}:${CONDA_PREFIX}/Scripts:${PATH}
  cmd "/C echo %PATH% > C:\log.txt"  
  cat /c/log.txt
  ls ${CONDA_PREFIX}
  ls ${CONDA_PREFIX}/Scripts
fi

if [[ "${TRAVIS_OS_NAME}" = "windows" ]]; then
  cmd "/C conda.exe activate"
else
  conda activate
fi

if [[ ! "${ANACONDA_CHANNELS}" = "" ]]; then
  conda config ${ANACONDA_CHANNELS}
  if [[ "${TRAVIS_OS_NAME}" = "windows" ]]; then
    cmd "/C conda config %ANACONDA_CHANNELS%"
  else
    conda config ${ANACONDA_CHANNELS}
  fi
fi
if [[ "${TRAVIS_OS_NAME}" = "windows" ]]; then
  cmd "/C conda config --set always_yes yes"
  cmd "/C conda config --set remote_read_timeout_secs 600"
  cmd "/C conda config --set auto_update_conda False"
else
  conda config --set always_yes yes
  conda config --set remote_read_timeout_secs 600
  conda config --set auto_update_conda False
fi

if [[ ! "${CONDA_PIN}" = "" ]]; then
  if [[ "${TRAVIS_OS_NAME}" = "windows" ]]; then
    cmd "/C conda install conda=%CONDA_PIN%"
  else
    conda install conda=${CONDA_PIN}
  fi
fi

if [[ ! "${CONDA_BUILD_PIN}" = "" ]]; then
  if [[ "${TRAVIS_OS_NAME}" = "windows" ]]; then
    cmd "/C conda install conda-build=%CONDA_BUILD_PIN%"
  else
    conda install conda-build=${CONDA_BUILD_PIN}
  fi 
else
  if [[ "${TRAVIS_OS_NAME}" = "windows" ]]; then
    cmd "/C conda install conda-build"
  else
    conda install conda-build
  fi
fi

if [[ ! "${CONDA_VERIFY_PIN}" = "" ]]; then
  if [[ "${TRAVIS_OS_NAME}" = "windows" ]]; then
    cmd "/C conda install conda-verify=${CONDA_BUILD_PIN}"
  else
    conda install conda-verify=${CONDA_BUILD_PIN}
  fi
else
  if [[ "${TRAVIS_OS_NAME}" = "windows" ]]; then
    cmd "/C conda install conda-verify"
  else
    conda install conda-verify
  fi
fi
if [[ ! "${ANACONDA_CLIENT_PIN}" = "" ]]; then
  if [[ "${TRAVIS_OS_NAME}" = "windows" ]]; then
    cmd "/C conda install anaconda-client=%ANACONDA_CLIENT_PIN%"
  else
    conda install anaconda-client=${ANACONDA_CLIENT_PIN}
  fi
else
  if [[ "${TRAVIS_OS_NAME}" = "windows" ]]; then
    cmd "/C conda install anaconda-client"
  else
    conda install anaconda-client
  fi
fi

if [[ "${TRAVIS_OS_NAME}" = "windows" ]]; then
  cmd "/C anaconda config --set auto_register yes"
else
  anaconda config --set auto_register yes
fi

if [[ "${CI}" = "true" ]]; then
  if [[ "${TRAVIS_OS_NAME}" = "windows" ]]; then
    cmd "/C conda install requests"
    cmd "/C python release.py"
  else
    conda install requests
    python release.py
  fi
  if [[ ! "$?" = "0" ]]; then
    exit 1
  fi
fi

if [[ "${TRAVIS_OS_NAME}" = "windows" ]]; then
  cmd "/C conda create -n travis-ci python=%PYTHON_VERSION%"
else
  conda create -n travis-ci python=${PYTHON_VERSION}
fi

if [[ ! "${CONDA_PACKAGES}" = "" ]]; then
  if [[ "${TRAVIS_OS_NAME}" = "windows" ]]; then
    cmd "/C conda install -n travis-ci %CONDA_PACKAGES% --use-local"
  else
    conda install -n travis-ci ${CONDA_PACKAGES} --use-local
  fi
fi

if [[ "${TRAVIS_OS_NAME}" = "windows" ]]; then
  cmd "/C conda activate travis-ci"
else
  conda activate travis-ci
fi

set +ve