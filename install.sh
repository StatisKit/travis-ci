set -ev

if [[ "$TRAVIS_OS_NAME" = "linux" ]]; then
  sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
  sudo apt-get update
  sudo apt-get install -qq gcc-5 g++-5
  sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 60 --slave /usr/bin/g++ g++ /usr/bin/g++-5
  wget https://raw.githubusercontent.com/StatisKit/StatisKit/master/doc/developer/developer_install.sh -O developer_install.sh;
elif [[ "$TRAVIS_OS_NAME" = "osx" ]]; then
  curl https://raw.githubusercontent.com/StatisKit/StatisKit/master/doc/developer/developer_install.sh -o developer_install.sh;
fi
export BATCH_MODE=true
set +ev
source developer_install.sh
set -ev
rm developer_install.sh

set +ev
