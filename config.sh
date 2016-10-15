set -e

if [[ "$TRAVIS_OS_NAME" = "linux" ]]; then
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
conda update -q conda
conda info -a
conda install conda-build=2.0.2
conda install anaconda-client
pip install python-coveralls

set +e