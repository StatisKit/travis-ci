set -ev

echo $RECIPE

if [[ -z "$RECIPE" ]]; then
  conda build ../conda/$RECIPE -c conda-forge -c statiskit
fi

set +ev