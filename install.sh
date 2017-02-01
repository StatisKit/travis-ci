set -ev

if [[ "$TRAVIS_OS_NAME" = "linux" ]]; then
  sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
  sudo apt-get update
  sudo apt-get install -qq gcc-5 g++-5
  sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 60 --slave /usr/bin/g++ g++ /usr/bin/g++-5
  if [[ "$TRAVIS_BRANCH" = "linux32" ]]; then
    export PLATFORM="x86"
  else
    export PLATFORM="x86_64"
  fi
  if [[ "$MINICONDA" = "3" ]]; then
    wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-$PLATFORM.sh -O miniconda.sh;
  else
    wget https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-$PLATFORM.sh -O miniconda.sh;
  fi
elif [[ "$TRAVIS_OS_NAME" = "osx" ]]; then
  if [[ "$TRAVIS_BRANCH" = "linux32" ]]; then
    exit 1
  fi
  if [[ "$MINICONDA" = "3" ]]; then
    curl https://repo.continuum.io/miniconda/Miniconda3-latest-MacOSX-x86_64.sh -o miniconda.sh;
  else
    curl https://repo.continuum.io/miniconda/Miniconda2-latest-MacOSX-x86_64.sh -o miniconda.sh;
  fi
fi
bash miniconda.sh -b -p $HOME/miniconda
export PATH=$HOME/miniconda/bin:$PATH
conda config --set always_yes yes --set changeps1 no
conda update -q conda
conda info -a
conda install conda-build
conda install anaconda-client
pip install python-coveralls

rm miniconda.sh

set +ev
