export TEST_LEVEL=1
conda config --set always_yes yes
conda config --add channels r
conda config --add channels statiskit
if [[ ! "$ANACONDA_UPLOAD" = "statiskit" ]]; then
  conda config --add channels statiskit/label/unstable
  conda config --add channels $ANACONDA_UPLOAD
  if [[ ! "$ANACONDA_LABEL" = "main" ]]; then
      conda config --add channels $ANACONDA_UPLOAD/label/$ANACONDA_LABEL
  fi
else
  if [[ ! "$ANACONDA_LABEL" = "main" ]]; then
      conda config --add channels statiskit/label/$ANACONDA_LABEL
  fi
fi
