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
    if [[ ! "$DOCKER_CONTEXT" = "" ]]; then
        docker push ${DOCKER_UPLOAD}/${DOCKER_CONTAINER}:${TRAVIS_TAG}-py${CONDA_VERSION}k
        if [[ ! "$TRAVIS_TAG" = "latest" ]]; then
            docker tag ${DOCKER_UPLOAD}/${DOCKER_CONTAINER}:${TRAVIS_TAG}-py${CONDA_VERSION}k ${DOCKER_UPLOAD}/${DOCKER_CONTAINER}:latest-py${CONDA_VERSION}k
            docker push ${DOCKER_UPLOAD}/${DOCKER_CONTAINER}:latest-py${CONDA_VERSION}k
        fi
    fi
fi

if [[ "$ANACONDA_DEPLOY" = "true" ]]; then
  if [[ ! "$CONDA_RECIPE" = "" ]]; then
      anaconda upload `conda build $OLD_BUILD_STRING_ARG --python=$PYTHON_VERSION ../$CONDA_RECIPE --output` -u $ANACONDA_UPLOAD $ANACONDA_FORCE_ARG --label $ANACONDA_LABEL_ARG
  fi
fi

if [[ "$ANACONDA_RELEASE" = "true" ]]; then
  if [[ "$TRAVIS_BRANCH" = "master" ]]; then
    if [[ "$TRAVIS_EVENT_TYPE" = "cron" ]]; then
      anaconda label -o $ANACONDA_UPLOAD --copy $ANACONDA_LABEL_ARG cron
    else
      anaconda label -o $ANACONDA_UPLOAD --copy $ANACONDA_LABEL_ARG main
    fi
    anaconda label -o $ANACONDA_UPLOAD --remove $ANACONDA_LABEL_ARG
  fi
fi

set +ev
