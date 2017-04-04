set -ev

if [[ ! "$ANACONDA_OFFICIAL" = "true" ]]; then
  export ANACONDA_OFFICIAL=false
fi

if [[ "$ANACONDA_OFFICIAL" = "true" ]]; then
  export ANACONDA_CHANNELS="-c statiskit -c conda-forge"
  export ANACONDA_UPLOAD="statiskit"
else
  export ANACONDA_CHANNELS="-c $ANACONDA_USERNAME -c statiskit -c conda-forge"
  export ANACONDA_UPLOAD=$ANACONDA_USERNAME
fi

if [[ "$TRAVIS_OS_NAME" = "linux" ]]; then
  sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
  if [[ "$PLATFORM" = "x86" ]]; then
    sudo apt-get install ia32-libs
  fi
  sudo apt-get update
  sudo apt-get install -qq gcc-5 g++-5
  sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 60 --slave /usr/bin/g++ g++ /usr/bin/g++-5
  wget https://raw.githubusercontent.com/StatisKit/StatisKit/master/doc/developer/developer_install.sh -O developer_install.sh;
elif [[ "$TRAVIS_OS_NAME" = "osx" ]]; then
  curl https://raw.githubusercontent.com/StatisKit/StatisKit/master/doc/developer/developer_install.sh -o developer_install.sh;
fi
export BATCH_MODE=true
export CONFIGURE_ONLY=true
set +e
source developer_install.sh
set -ev
rm developer_install.sh

set +ev
