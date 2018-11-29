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
miniconda /AddToPath=1 /InstallationType=JustMe /RegisterPython=0 /S /D=%CONDA_PREFIX% 
if errorlevel 1 exit 1
del miniconda.exe
if errorlevel 1 exit 1
call %CONDA_PREFIX%\Scripts\activate.bat
if errorlevel 1 exit 1
conda.exe --help

rem if not "%ANACONDA_CHANNELS%" == "" (
rem   conda config %ANACONDA_CHANNELS%
rem   if errorlevel 1 exit 1
rem )
rem conda config --set always_yes yes
rem if errorlevel 1 exit 1
rem conda config --set remote_read_timeout_secs 600
rem if errorlevel 1 exit 1
rem conda config --set auto_update_conda False
rem if errorlevel 1 exit 1

rem if not "%CONDA_PIN%" == "" conda install conda=%CONDA_PIN%
rem if not "%CONDA_BUILD_PIN%" == "" (
rem   conda install conda-build=%CONDA_BUILD_PIN%
rem   if errorlevel 1 exit 1 
rem ) else (
rem   conda install conda-build
rem   if errorlevel 1 exit 1
rem )

rem if "%CI%" == "true" (
rem   python release.py
rem   if errorlevel 1 exit 1
rem )
rem if not "%ANACONDA_CLIENT_PIN%" == "" (
rem     conda install anaconda-client=$ANACONDA_CLIENT_PIN
rem     if errorlevel 1 exit 1
rem ) else (
rem     conda install anaconda-client
rem     if errorlevel 1 exit 1
rem )
rem anaconda config --set auto_register yes
rem if errorlevel 1 exit 1

rem set CMD_IN_ENV=cmd /E:ON /V:ON /C %cd%\\cmd_in_env.cmd
rem if errorlevel 1 exit 1

rem conda create -n travis-ci python=%PYTHON_VERSION%
rem if errorlevel 1 exit 1

rem if not "%CONDA_PACKAGES%" == "" (
rem   conda install -n travis-ci %CONDA_PACKAGES% --use-local
rem   if errorlevel 1 exit 1
rem )

rem conda activate travis-ci
rem if errorlevel 1 exit 1

rem python python_version.py
rem if errorlevel 1 exit 1

rem echo conda activate travis-ci >> environ.bat

echo OFF
