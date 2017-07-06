set -ev

if [[ ! "$RECIPE" = "" ]]; then
	if [[ -f ../conda/$RECIPE/travis-ci.patch ]]; then
		cd ..
		git apply -v conda/$RECIPE/travis-ci.patch
		cd travis-ci
	fi
fi

if [[ ! "$ENVIRONMENT" = "" ]]; then
	conda env create -f ../environment.yml
	source activate $ENVIRONMENT
fi

set +ev
