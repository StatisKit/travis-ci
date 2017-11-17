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

if [[ "$DOCKER_DEPLOY" = "true" ]]; then
    if [[ ! "$DOCKERFILE" = "" ]]; then
        eval "docker push "$DOCKER_UPLOAD"/"$DOCKER_REPOSITORY":"$TRAVIS_TAG"-py"$CONDA_VERSION"k"
        if [[ ! "$TRAVIS_TAG" = "latest" ]]; then
            eval "docker tag "$DOCKER_UPLOAD"/"$DOCKER_REPOSITORY":"$TRAVIS_TAG"-py"$CONDA_VERSION"k"$DOCKER_UPLOAD"/"$DOCKER_REPOSITORY":latest-py"$CONDA_VERSION"k"
            eval "docker push "$DOCKER_UPLOAD"/"$DOCKER_REPOSITORY":latest-py"$CONDA_VERSION"k"
        fi
    fi
fi

if [[ "$ANACONDA_DEPLOY" = "true" ]]; then
  if [[ ! "$CONDA_RECIPE" = "" ]]; then
      anaconda upload `conda build --old-build-string --python=$PYTHON_VERSION ../$CONDA_RECIPE --output | tr -s "\n" " "` -u $ANACONDA_UPLOAD --force --no-progress --label $ANACONDA_LABEL
  fi
fi

set +ev
