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

if [[ ! "$CONDA_RECIPE" = "" ]]; then
  $TRAVIS_WAIT conda build $OLD_BUILD_STRING_ARG --python=$PYTHON_VERSION ../$CONDA_RECIPE
elif [[ ! "$JUPYTER_NOTEBOOK" = "" ]]; then
  $TRAVIS_WAIT jupyter nbconvert --ExecutePreprocessor.kernel_name='python'$CONDA_VERSION --ExecutePreprocessor.timeout=0 --to notebook --execute ../$JUPYTER_NOTEBOOK --output ../$JUPYTER_NOTEBOOK
elif [[ ! "$DOCKER_CONTEXT" = "" ]]; then
  mv ../$DOCKER_CONTEXT $DOCKER_CONTAINER
  cp $HOME/.condarc $DOCKER_CONTAINER/.condarc
  $TRAVIS_WAIT sudo docker build --build-arg CONDA_VERSION=${CONDA_VERSION} -t ${DOCKER_UPLOAD}/${DOCKER_CONTAINER}:${TRAVIS_TAG}-py${CONDA_VERSION}k ${DOCKER_CONTAINER}
  mv $DOCKER_CONTAINER ../$DOCKER_CONTEXT
fi

set +ev
