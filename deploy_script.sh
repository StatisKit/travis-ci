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

if [[ "${DOCKER_DEPLOY}" = "true" ]]; then
    if [[ ! "${DOCKER_CONTEXT}" = "" ]]; then
        if [[ ! "${CONDA_VERSION}" = "3" ]]; then
            sudo docker push ${DOCKER_OWNER}/${DOCKER_CONTAINER}:${TRAVIS_TAG}-py${CONDA_VERSION}k
        else
            sudo docker push ${DOCKER_OWNER}/${DOCKER_CONTAINER}:${TRAVIS_TAG}
        fi
        if [[ ! "${TRAVIS_TAG}" = "latest" ]]; then
            if [[ ! "${CONDA_VERSION}" = "3" ]]; then
                sudo docker tag ${DOCKER_OWNER}/${DOCKER_CONTAINER}:${TRAVIS_TAG}-py${CONDA_VERSION}k ${DOCKER_OWNER}/${DOCKER_CONTAINER}:latest-py${CONDA_VERSION}k
                sudo docker push ${DOCKER_OWNER}/${DOCKER_CONTAINER}:latest-py${CONDA_VERSION}k
            else
                sudo docker tag ${DOCKER_OWNER}/${DOCKER_CONTAINER}:${TRAVIS_TAG} ${DOCKER_OWNER}/${DOCKER_CONTAINER}:latest
                sudo docker push ${DOCKER_OWNER}/${DOCKER_CONTAINER}:latest
            fi
        fi
    fi
fi

if [[ "${ANACONDA_DEPLOY}" = "true" ]]; then
  if [[ ! "${CONDA_RECIPE}" = "" ]]; then
      if [[ "${ANACONDA_FORCE}" = "" ]]; then
        set +e
      fi
      anaconda upload ${ANACONDA_PACKAGES} -u ${ANACONDA_OWNER} ${ANACONDA_FORCE} --label ${ANACONDA_TMP_LABEL} --no-progress
      rm ${ANACONDA_PACKAGES}
      if [[ "${ANACONDA_FORCE}" = "" ]]; then
        set -e
      fi
  fi
fi

if [[ "${ANACONDA_RELEASE}" = "true" ]]; then
  if [[ ! "${ANACONDA_TMP_LABEL}" = "${ANACONDA_LABEL}" ]]; then
      anaconda label -o ${ANACONDA_OWNER} --copy ${ANACONDA_TMP_LABEL} ${ANACONDA_LABEL}
  fi
fi

set +ev
