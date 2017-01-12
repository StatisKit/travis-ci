set -e

if [[ "$TRAVIS_OS_NAME" = "linux" ]]; then
  sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
  sudo apt-get update
  sudo apt-get install -qq gcc-5 g++-5
  sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 60 --slave /usr/bin/g++ g++ /usr/bin/g++-5
  if [[ "$MINICONDA" = "3" ]]; then
    wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh;
  else
    wget https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh -O miniconda.sh;
  fi
 elif [[ "$TRAVIS_OS_NAME" = "osx" ]]; then
  if [[ "$MINICONDA" = "3" ]]; then
    curl https://repo.continuum.io/miniconda/Miniconda3-latest-MacOSX-x86_64.sh -o miniconda.sh;
  else
    curl https://repo.continuum.io/miniconda/Miniconda2-latest-MacOSX-x86_64.sh -o miniconda.sh;
  fi
fi
bash miniconda.sh -b -p $HOME/miniconda
export PATH=$HOME/miniconda/bin:$PATH
conda config --set always_yes yes --set changeps1 no
# if [[ ! "$CONDA_CACHE_DIR" = "" ]]; then
#   echo "conda-build:" >> $HOME/.condarc;
#   echo "  root-dir: " $CONDA_CACHE_DIR >> $HOME/.condarc;
#   if [[ ! -f $CONDA_CACHE_DIR/$TRAVIS_BUILD_NUMBER ]]; then
#     rm -rf $CONDA_CACHE_DIR;
#     mkdir $CONDA_CACHE_DIR;
#     touch $CONDA_CACHE_DIR/$TRAVIS_BUILD_NUMBER;
#   fi
# fi
conda update -q conda
conda info -a
conda install conda-build
conda install anaconda-client
pip install python-coveralls

set +e