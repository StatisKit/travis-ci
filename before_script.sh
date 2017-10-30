set -ev

if [[ ! "$CONDA_RECIPE" = "" ]]; then
    if [[ -f ../bin/conda/$CONDA_RECIPE/travis-ci.patch ]]; then
        cd ..
        git apply -v bin/conda/$CONDA_RECIPE/travis-ci.patch
        cd travis-ci
    fi
fi

if [[ ! "$CONDA_ENVIRONMENT" = "" ]]; then
    conda create -n $CONDA_ENVIRONMENT python=$CONDA_VERSION
    source activate $CONDA_ENVIRONMENT
    conda env update -f ../environment.yml
    source activate $CONDA_ENVIRONMENT
fi

set +ev
