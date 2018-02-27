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

if [[ "$ANACONDA_LABEL" = "release" ]]; then
    if [[ "$TRAVIS_BRANCH" = "master" || ! "$TRAVIS_TAG" = "latest" ]]; then
        export ANACONDA_FORCE="false"
    else
        export ANACONDA_FORCE="true"
    fi
else
    export ANACONDA_FORCE="true"
fi

if [[ "$ANACONDA_LABEL" = "release" ]]; then
    if [[ "$TRAVIS_BRANCH" = "master" || ! "$TRAVIS_TAG" = "latest" ]]; then
        export OLD_BUILD_STRING="false"
        export ANACONDA_LABEL_ARG=$TRAVIS_OS_NAME-$ARCH"_release"
    else
        export OLD_BUILD_STRING="true"
        export ANACONDA_LABEL_ARG="develop"
    fi
else
    export OLD_BUILD_STRING="true"
    export ANACONDA_LABEL_ARG=$ANACONDA_LABEL
fi

export TEST_LEVEL=1
conda config --add channels r

if [[ "$ANACONDA_OWNER" = "statiskit" && ! "$ANACONDA_LABEL" = "release" && ! "$ANACONDA_LABEL" = "develop" ]]; then
    echo "Variable ANACONDA_LABEL set to '"$ANACONDA_LABEL"' instead of 'release' or 'develop'"
    exit 1
fi

if [[ ! "$ANACONDA_OWNER" = "statiskit" ]]; then
    conda config --add channels statiskit
    if [[ ! "$ANACONDA_LABEL_ARG" = "release" ]]; then
        conda config --add channels statiskit/label/$ANACONDA_LABEL_ARG
    fi
fi

if [[ ! "$ANACONDA_OWNER" = "" ]]; then
    conda config --add channels $ANACONDA_OWNER
    if [[ ! "$ANACONDA_LABEL_ARG" = "main" ]]; then
        conda config --add channels $ANACONDA_OWNER/label/$ANACONDA_LABEL_ARG
    fi
fi
