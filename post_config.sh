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

anaconda config --set auto_register yes

if [[ "$ANACONDA_LABEL_ARG" = "" ]]; then
  export ANACONDA_LABEL_ARG=$ANACONDA_LABEL
fi

if [[ "$OLD_BUILD_STRING" = "true" ]]; then
    export OLD_BUILD_STRING_ARG="--old-build-string"
else
    export OLD_BUILD_STRING_ARG=
fi

if [[ "$ANACONDA_FORCE" = "true" ]]; then
    export ANACONDA_FORCE_ARG="--force"
else
    export ANACONDA_FORCE_ARG=
fi
