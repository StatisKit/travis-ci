set -ev

if [[ "$CONDA_VERSION" = "" ]]; then
  export CONDA_VERSION=2
fi

if [[ ! "$ANACONDA_OFFICIAL" = "true" && ! "$ANACONDA_USERNAME" = "" ]]; then
  export ANACONDA_CHANNELS="-c $ANACONDA_USERNAME -c statiskit -c conda-forge "$ANACONDA_CHANNELS
  export ANACONDA_UPLOAD=$ANACONDA_USERNAME
else
  export ANACONDA_CHANNELS="-c statiskit -c conda-forge "$ANACONDA_CHANNELS
  export ANACONDA_UPLOAD="statiskit"
fi

if [[ "$TRAVIS_OS_NAME" = "linux" ]]; then
  sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
  if [[ "$PLATFORM" = "x86" ]]; then
    sudo apt-get install ia32-libs
  fi
  sudo apt-get update
  sudo apt-get install -qq gcc-5 g++-5
  sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 60 --slave /usr/bin/g++ g++ /usr/bin/g++-5
  if [[ ! "$DOCKERFILE" = "" ]]; then
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt-get update
    sudo apt-get -y install docker-ce
  fi
fi
curl "https://raw.githubusercontent.com/StatisKit/install-binaries/master/"$TRAVIS_OS_NAME"/PY"$CONDA_VERSION/"developer_install" -o developer_install;
chmod a+rwx developer_install
./developer_install --prepend-path=no --configure-only=yes --prefix=$HOME/miniconda
rm developer_install
export PATH=$HOME/miniconda/bin:$PATH
export TEST_LEVEL=1
source activate root
export PYTHON_VERSION=`python -c "import sys; print(str(sys.version_info.major) + str(sys.version_info.minor))"`

set +ev
