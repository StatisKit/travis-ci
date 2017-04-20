set +ve

git clone https://github.com/StatisKit/install-binaries.git --depth=1
if [[ ! -d $TRAVIS_OS_NAME ]]; then
  mkdir $TRAVIS_OS_NAME
fi
if [[ -f $TRAVIS_OS_NAME"/"$INSTALL"_install" ]]; then
  rm $TRAVIS_OS_NAME"/"$INSTALL"_install"
fi
mv $INSTALL"_install" $TRAVIS_OS_NAME"/"$INSTALL"_install"
sudo chmod a+rwx $TRAVIS_OS_NAME"/"$INSTALL"_install"
cd StatisKit
git config --global user.email $GIT_EMAIL
git config --global user.name $GIT_NAME
git add "doc/"$TRAVIS_OS_NAME"/"$INSTALL"_install"
git commit -a -m "Update "$TRAVIS_OS_NAME"/"$INSTALL"_install script"
echo "machine github.com" >> ~/.netrc
echo "       login "$GITHUB_USERNAME >> ~/.netrc
echo "       password "$GITHUB_PASSWORD >> ~/.netrc
git push

set +ve