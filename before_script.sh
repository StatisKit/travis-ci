set -ev

if [[ ! "$RECIPE" = "" ]]; then
	if [[ -f ../conda/$RECIPE/travis-ci.patch ]]; then
		git apply -v ../conda/$RECIPE/travis-ci.patch
	fi
fi

set +ev