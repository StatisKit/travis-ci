set -ev

if [[ ! "$CONDA_RECIPE" = "" ]]; then
	if [[ -f ../bin/$CONDA_RECIPE/travis-ci.patch ]]; then
		cd ..
		git apply -v bin/$CONDA_RECIPE/travis-ci.patch
		cd travis-ci
	fi
fi

if [[ ! "$CONDA_ENVIRONMENT" = "" ]]; then
	conda env create -f ../environment.yml
	source activate $CONDA_ENVIRONMENT
fi

set +ev
