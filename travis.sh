set -ve

git clone https://github.com/StatisKit/StatisKit.git
if [[ -f StatisKit/doc/$TRAVIS_ON_NAME_$INSTALL ]]; then
  rm StatisKit/doc/$TRAVIS_ON_NAME_$INSTALL
fi
mv $INSTALL StatisKit/doc/$TRAVIS_OS_NAME_$INSTALL
cd StatisKit
git config --global user.email $GIT_EMAIL
git config --global user.name $GIT_NAME
git commit -a -m "Update "$TRAVIS_OS_NAME_$INSTALL" script"
echo "machine github.com" >> ~/.netrc
echo "       login "$GITHUB_USERNAME >> ~/.netrc
echo "       password "$GITHUB_PASSWORD >> ~/.netrc
git push

set +ve
