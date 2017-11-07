set -ev

if [[ ! "$CONDA_ENVIRONMENT" = "" ]]; then
    conda create -n travis-ci python=$CONDA_VERSION
    source activate travis-ci
    conda env update -f ../$CONDA_ENVIRONMENT
    source activate travis-ci
fi

set +ev
