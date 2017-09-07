
git clone https://github.com/StatisKit/install-binaries.git --depth=1
if [[ ! -d "install-binaries/"$TRAVIS_OS_NAME ]]; then
  mkdir "install-binaries/"$TRAVIS_OS_NAME
fi
if [[ ! -d "install-binaries/"$TRAVIS_OS_NAME"/PY"$PYTHON_VERSION ]]; then
  mkdir "install-binaries/"$TRAVIS_OS_NAME"/PY"$PYTHON_VERSION
fi
if [[ -f "install-binaries/"$TRAVIS_OS_NAME"/PY"$PYTHON_VERSION"/"$INSTALL"_install" ]]; then
  rm "install-binaries/"$TRAVIS_OS_NAME"/PY"$PYTHON_VERSION"_install"
fi
ls install-binaries/"$TRAVIS_OS_NAME"
mv $INSTALL"_install install-binaries/"$TRAVIS_OS_NAME"/PY"$PYTHON_VERSION"/"$INSTALL"_install"
ls install-binaries/"$TRAVIS_OS_NAME"/PY"$PYTHON_VERSION"
cd install-binaries
git config --global user.email $GIT_EMAIL
git config --global user.name $GIT_NAME
git add $TRAVIS_OS_NAME"/PY"$PYTHON_VERSION"/"$INSTALL"_install"
git commit -a -m "Update "$TRAVIS_OS_NAME"/PY"$PYTHON_VERSION"/"$INSTALL"_install"
set +ve
echo "machine github.com" >> ~/.netrc
echo "       login "$GITHUB_USERNAME >> ~/.netrc
echo "       password "$GITHUB_PASSWORD >> ~/.netrc
git push
rm  ~/.netrc
cd ..

set +ve
