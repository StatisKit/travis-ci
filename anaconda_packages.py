import os
import sys

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
    CONDA_PREFIX = os.path.join(os.path.abspath(environ["CONDA_PREFIX"]), 'conda-bld', environ["TRAVIS_OS_NAME"] + "-")
    CONDA_PREFIX = CONDA_PREFIX.replace("windows", "win")
    if environ["ARCH"] == "x86":
        CONDA_PREFIX += "32"
    else:
        CONDA_PREFIX += "64"
    if os.path.exists(CONDA_PREFIX):
        environ["ANACONDA_SUCCESS_PACKAGES"] = " ".join(os.path.join(CONDA_PREFIX, package) for package in os.listdir(CONDA_PREFIX) if package.endswith(".tar.bz2"))
    else:
        environ["ANACONDA_SUCCESS_PACKAGES"] = ""
    CONDA_PREFIX = os.path.join(os.path.abspath(environ["CONDA_PREFIX"]), 'conda-bld', "broken")
    if os.path.exists(CONDA_PREFIX):
        environ["ANACONDA_FAILURE_PACKAGES"] = " ".join(os.path.join(CONDA_PREFIX, package) for package in os.listdir(CONDA_PREFIX) if package.endswith(".tar.bz2"))
    else:
        environ["ANACONDA_FAILURE_PACKAGES"] = ""
    if environ["TRAVIS_OS_NAME"] == "windows":
        with open("anaconda_packages.bat", "a+") as filehandler:
            filehandler.write("\n")
            if PY2:
                for key, value in environ.iteritems():
                    if key not in os.environ or not os.environ[key] == environ[key]:
                        filehandler.write("set " + key + "=" + value.strip() + "\n")
                        filehandler.write("if errorlevel 1 exit 1")
            else:
                for key, value in environ.items():
                    if key not in os.environ or not os.environ[key] == environ[key]:
                        filehandler.write("set " + key + "=" + value.strip() + "\n")
                        filehandler.write("if errorlevel 1 exit 1")
            filehandler.write("\n")
    else:
        with open("anaconda_packages.sh", "a+") as filehandler:
            filehandler.write("\n")
            if PY2:
                for key, value in environ.iteritems():
                    if key not in os.environ or not os.environ[key] == environ[key]:
                        filehandler.write("export " + key + "=\"" + value.strip() + "\"\n")
            else:
                for key, value in environ.items():
                    if key not in os.environ or not os.environ[key] == environ[key]:
                        filehandler.write("export " + key + "=\"" + value.strip() + "\"\n")
            filehandler.write("\n")

if __name__ == "__main__":
    main()