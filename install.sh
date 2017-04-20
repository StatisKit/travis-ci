set -ev

if [[ ! "$ANACONDA_OFFICIAL" = "true" ]]; then
  export ANACONDA_CHANNELS="-c $ANACONDA_USERNAME -c statiskit -c conda-forge"
  export ANACONDA_UPLOAD=$ANACONDA_USERNAME
else
  export ANACONDA_CHANNELS="-c statiskit -c conda-forge"
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
fi
curl "https://raw.githubusercontent.com/StatisKit/install-binaries/master/"$TRAVIS_OS_NAME"/developer_install" -o developer_install;
chmod a+rwx developer_install
./developer_install --prepend-path=no --configure-only=yes --prefix=$HOME/miniconda
rm developer_install
export PATH=$HOME/miniconda/bin:$PATH

set +ev
