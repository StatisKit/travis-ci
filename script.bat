:: Copyright [2017-2018] UMR MISTEA INRA, UMR LEPSE INRA,                ::
::                       UMR AGAP CIRAD, EPI Virtual Plants Inria        ::
::                                                                       ::
:: This file is part of the StatisKit project. More information can be   ::
:: found at                                                              ::
::                                                                       ::
::     http://autowig.rtfd.io                                            ::
::                                                                       ::
:: The Apache Software Foundation (ASF) licenses this file to you under  ::
:: the Apache License, Version 2.0 (the "License"); you may not use this ::
:: file except in compliance with the License. You should have received  ::
:: a copy of the Apache License, Version 2.0 along with this file; see   ::
:: the file LICENSE. If not, you may obtain a copy of the License at     ::
::                                                                       ::
::     http://www.apache.org/licenses/LICENSE-2.0                        ::
::                                                                       ::
:: Unless required by applicable law or agreed to in writing, software   ::
:: distributed under the License is distributed on an "AS IS" BASIS,     ::
:: WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or       ::
:: mplied. See the License for the specific language governing           ::
:: permissions and limitations under the License.                        ::

echo OFF

call environ.bat

echo ON

call %CONDA_PREFIX%\Scripts\activate.bat travis-ci
if errorlevel 1 exit 1
python python_version.py
if errorlevel 1 exit 1
call python_version.bat
if errorlevel 1 exit 1

type C:\miniconda\lib\site-packages\libarchive\ffi.py

if not "%CONDA_RECIPE%" == "" (
  %CMD_IN_ENV% conda.exe build %OLD_BUILD_STRING% --python=%PYTHON_VERSION% %CONDA_RECIPE%
  if errorlevel 1 exit 1
)

if not "%JUPYTER_NOTEBOOK%" == "" (
  jupyter nbconvert --ExecutePreprocessor.kernel_name=%JUPYTER_KERNEL% --ExecutePreprocessor.timeout=0 --to notebook --execute --inplace %JUPYTER_NOTEBOOK%
  if errorlevel 1 exit 1
)

echo OFF
