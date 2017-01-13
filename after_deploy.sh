set -ev

if [[ "$DOCKER_DEPLOY" = "true" ]]; then
  docker logout
fi

if [[ "$ANACONDA_DEPLOY" = "true" ]]; then
  anaconda logout
fi

set +ev