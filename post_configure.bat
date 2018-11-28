echo ON

git -C %APPVEYOR_BUILD_FOLDER% submodule update --init --recursive

if "%CI%" == "True" rmdir /s /q C:\Miniconda
if errorlevel 1 exit 1
curl https://repo.continuum.io/miniconda/Miniconda%CONDA_VERSION%-latest-Windows-%ARCH%.exe -o miniconda.exe
if errorlevel 1 exit 1
miniconda.exe /AddToPath=1 /InstallationType=JustMe /RegisterPython=0 /S /D=%HOMEDRIVE%\Miniconda 
if errorlevel 1 exit 1
del miniconda.exe
if errorlevel 1 exit 1
set PATH=%HOMEDRIVE%\Miniconda;%HOMEDRIVE%\Miniconda\Scripts;%PATH%
if errorlevel 1 exit 1
call activate.bat
if errorlevel 1 exit 1
if not "%ANACONDA_CHANNELS%" == "" (
  conda.exe config %ANACONDA_CHANNELS%
  if errorlevel 1 exit 1
)
conda.exe config --set always_yes yes
if errorlevel 1 exit 1
conda.exe config --set remote_read_timeout_secs 600
if errorlevel 1 exit 1
conda.exe config --set auto_update_conda False
if errorlevel 1 exit 1

if not "%CONDA_PIN%" == "" conda.exe install conda=%CONDA_PIN%
if not "%CONDA_BUILD_PIN%" == "" (
  conda.exe install conda-build=%CONDA_BUILD_PIN%
  if errorlevel 1 exit 1 
) else (
  conda.exe install conda-build
  if errorlevel 1 exit 1
)

if "%CI%" == "True" (
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
anaconda config --set auto_register yes
if errorlevel 1 exit 1

set CMD_IN_ENV=cmd /E:ON /V:ON /C %cd%\\cmd_in_env.cmd
if errorlevel 1 exit 1

conda.exe create -n py%CONDA_VERSION%k python=%PYTHON_VERSION%
if errorlevel 1 exit 1
call activate.bat py%CONDA_VERSION%k
if errorlevel 1 exit 1

if not "%CONDA_PACKAGES%" == "" (
  conda.exe install  -n py%CONDA_VERSION% %CONDA_PACKAGES% --use-local
  if errorlevel 1 exit 1
  call activate.bat py%CONDA_VERSION%
  if errorlevel 1 exit 1
)

echo OFF