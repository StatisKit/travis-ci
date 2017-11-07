export TEST_LEVEL=1
conda config --set always_yes yes
conda config --add channels r
conda config --add channels statiskit
if [[ ! "$ANACONDA_UPLOAD" = "statiskit" ]]; then
  conda config --add channels $ANACONDA_UPLOAD
fi
