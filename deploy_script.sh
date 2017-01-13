set -ev

if [[ "$ANACONDA_DEPLOY" = "true" ]]; then
  anaconda upload `conda build ../conda/$RECIPE -c conda-forge -c statiskit --output` -u statiskit
fi

set +ev