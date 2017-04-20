set +ve

git clone https://github.com/StatisKit/install-binaries.git --depth=1
if [[ ! -d "install-binaries/"$TRAVIS_OS_NAME ]]; then
  mkdir "install-binaries/"$TRAVIS_OS_NAME
fi
if [[ -f "install-binaries/"$TRAVIS_OS_NAME"/"$INSTALL"_install" ]]; then
  rm "install-binaries/"$TRAVIS_OS_NAME"/"$INSTALL"_install"
fi
mv $INSTALL"_install" "install-binaries/"$TRAVIS_OS_NAME"/"$INSTALL"_install"
cd install-binaries
git config --global user.email $GIT_EMAIL
git config --global user.name $GIT_NAME
git add "doc/"$TRAVIS_OS_NAME"/"$INSTALL"_install"
git commit -a -m "Update "$TRAVIS_OS_NAME"/"$INSTALL"_install script"
echo "machine github.com" >> ~/.netrc
echo "       login "$GITHUB_USERNAME >> ~/.netrc
echo "       password "$GITHUB_PASSWORD >> ~/.netrc
git push

set +ve