set -ev

if [[ ! "$RECIPE" = "" ]]; then
  conda build ../conda/$RECIPE -c conda-forge -c statiskit
fi

set +ev