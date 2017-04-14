set +ve

git clone https://github.com/StatisKit/StatisKit.git
if [[ ! -d StatisKit/doc/$TRAVIS_OS_NAME ]]; then
  mkdir StatisKit/doc/$TRAVIS_OS_NAME
fi
if [[ -f StatisKit/doc/$TRAVIS_OS_NAME"/"$INSTALL ]]; then
  rm StatisKit/doc/$TRAVIS_OS_NAME"/"$INSTALL
fi
mv $INSTALL StatisKit/doc/$TRAVIS_OS_NAME/$INSTALL
sudo chmod a+rwx StatisKit/doc/$TRAVIS_OS_NAME/$INSTALL
cd StatisKit
git config --global user.email $GIT_EMAIL
git config --global user.name $GIT_NAME
git add doc/$TRAVIS_OS_NAME"/"$INSTALL
git commit -a -m "Update "$TRAVIS_OS_NAME"/"$INSTALL" script"
echo "machine github.com" >> ~/.netrc
echo "       login "$GITHUB_USERNAME >> ~/.netrc
echo "       password "$GITHUB_PASSWORD >> ~/.netrc
git push

set +ve
