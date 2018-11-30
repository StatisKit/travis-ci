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

echo ON

call environ.bat

if "%CI%" == "false" git submodule update --init

if "%CI%" == "true" rmdir /s /q C:\Miniconda

curl https://repo.continuum.io/miniconda/Miniconda%CONDA_VERSION%-latest-Windows-%ARCH%.exe -o miniconda.exe
if errorlevel 1 exit 1
miniconda.exe /AddToPath=1 /InstallationType=JustMe /RegisterPython=0 /S /D=%CONDA_PREFIX% 
if errorlevel 1 exit 1
del miniconda.exe
if errorlevel 1 exit 1
call %CONDA_PREFIX%\Scripts\activate.bat
if errorlevel 1 exit 1

if not "%ANACONDA_CHANNELS%" == "" (
  conda.exe config %ANACONDA_CHANNELS%
  if errorlevel 1 exit 1
)
conda.exe config --set always_yes yes
if errorlevel 1 exit 1
conda.exe config --set remote_read_timeout_secs 600
if errorlevel 1 exit 1
conda.exe config --set auto_update_conda.exe False
if errorlevel 1 exit 1

if not "%CONDA_PIN%" == "" conda.exe install conda=%CONDA_PIN%
if not "%CONDA_BUILD_PIN%" == "" (
  conda.exe install conda-build=%CONDA_BUILD_PIN%
  if errorlevel 1 exit 1 
) else (
  conda.exe install conda-build
  if errorlevel 1 exit 1
)

if "%CI%" == "true" (
  python release.py
  if errorlevel 1 exit 1
)
if not "%ANACONDA_CLIENT_PIN%" == "" (
    conda.exe install anaconda-client=$ANACONDA_CLIENT_PIN
    if errorlevel 1 exit 1
) else (
    conda.exe install anaconda-client
    if errorlevel 1 exit 1
)
anaconda.exe config --set auto_register yes
if errorlevel 1 exit 1

set CMD_IN_ENV=cmd /E:ON /V:ON /C %cd%\\cmd_in_env.cmd
if errorlevel 1 exit 1

conda.exe create -n travis-ci python=%PYTHON_VERSION%
if errorlevel 1 exit 1

if not "%CONDA_PACKAGES%" == "" (
  conda.exe install -n travis-ci %CONDA_PACKAGES% --use-local
  if errorlevel 1 exit 1
)

echo call %CONDA_PREFIX%\Scripts\activate.bat travis-ci >> environ.bat

call %CONDA_PREFIX%\Scripts\activate.bat travis-ci
if errorlevel 1 exit 1

python python_version.py
if errorlevel 1 exit 1

echo OFF
