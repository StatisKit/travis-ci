import os
import platform
import sys
import yaml

if sys.version_info[0] == 2:
    PY2 = True
    PY3 = False
else:
    PY3 = True
    PY2 = False

if PY2:
    environ = {key : value for key, value in os.environ.iteritems() if value}
else:
    environ = {key : value for key, value in os.environ.items() if value}

def main():
    if "CONDA_RECIPE" in environ and "CONDA_FEATURE" in environ:
        CONDA_RECIPE = os.path.join("..", CONDA_RECIPE, "meta.yaml")
        if PY2:
            with open(CONDA_RECIPE, "r") as filehandler:
                CONDA_META = yaml.load(filehandler)
        else:
            with open(CONDA_RECIPE, "rb") as filehandler:
                CONDA_META = yaml.load(filehandler)
        build = CONDA_META.get("build", dict())
        build["features"] = build.get("features", []) + [environ["CONDA_FEATURE"]]
        build["track_features"] = build.get("track_features", []) + [environ["CONDA_FEATURE"]]
        CONDA_META["build"] = build
        if PY2:
            with open(CONDA_RECIPE, "w") as filehandler:
                CONDA_META = yaml.dump(CONDA_META, filehandler)
        else:
            with open(CONDA_RECIPE, "wb") as filehandler:
                CONDA_META = yaml.dump(CONDA_META, filehandler)
