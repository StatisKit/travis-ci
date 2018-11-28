echo "${TRAVIS_COMMIT_MESSAGE}" | grep -F -q "[skip travis]"
if [[ "$?" = "0" ]]; then
    exit 0
fi
echo "${TRAVIS_COMMIT_MESSAGE}" | grep -F -q "[travis skip]"
if [[ "${?}" = "0" ]]; then
    exit 0
fi
