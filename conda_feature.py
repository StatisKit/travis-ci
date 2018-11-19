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
        CONDA_RECIPE = os.path.join("..", environ["CONDA_RECIPE"], "meta.yaml")
        if PY2:
            with open(CONDA_RECIPE, "r") as filehandler:
                CONDA_META = yaml.load(filehandler)
        else:
            with open(CONDA_RECIPE, "rb") as filehandler:
                CONDA_META = yaml.load(filehandler)
        print(CONDA_META)
        build = CONDA_META.get("build", dict())
        build["features"] = build.get("features", [])
        if environ["CONDA_FEATURE"] not in build["features"]:
            build["features"].append(environ["CONDA_FEATURE"])
        if environ["CONDA_FEATURE"] not in build["track_features"]:
            build["track_features"].append(environ["CONDA_FEATURE"])
        CONDA_META["build"] = build
        print(CONDA_META)
        if PY2:
            with open(CONDA_RECIPE, "w") as filehandler:
                CONDA_META = yaml.dump(CONDA_META, filehandler)
        else:
            with open(CONDA_RECIPE, "w") as filehandler:
                CONDA_META = yaml.dump(CONDA_META, filehandler)

if __name__ == "__main__":
    main()