import os
import six
import platform
import sys

if six.PY2:
    __PREV__ = {key : value for key, value in os.environ.iteritems()}
else:
    __PREV__ = {key : value for key, value in os.environ.items()}

def set_travis_os_name():
    SYSTEM = platform.system() 
    if SYSTEM == "Linux":
        SYSTEM = "linux"
    elif SYSTEM == "Darwin":
        SYSTEM = "osx"
    elif SYSTEM == "Windows":
        SYSTEM = "win"
    else:
        raise NotImplementedError("Travis CI is not meant for '" + SYSTEM + "' operating systems")
    os.environ["TRAVIS_OS_NAME"] = SYSTEM

def set_arch():
    if sys.maxsize > 2**32:
        os.environ["ARCH"] = "x86_64"
    else:
        os.environ["ARCH"] = "x86"

def set_conda_version():
    if "PYTHON_VERSION" in os.environ:
        os.environ["CONDA_VERSION"] = os.environ["PYTHON_VERSION"].split(".")[0]
    else:
        os.environ["CONDA_VERSION"] = "3"

def set_anaconda_owner():
    if "ANACONDA_LOGIN" in os.environ:
        os.environ["ANACONDA_OWNER"] = os.environ["ANACONDA_LOGIN"]

def set_anaconda_deploy():
    os.environ["ANACONDA_DEPLOY"] = os.environ["CI"] 

def set_anaconda_release():
    if "ANACONDA_LABEL" in os.environ and os.environ["ANACONDA_LABEL"] == "release":
        os.environ["ANACONDA_RELEASE"] = "true"
    else:
        os.environ["ANACONDA_RELEASE"] = "false"

def set_anaconda_label():
    if "TRAVIS_EVENT_TYPE" in os.environ and os.environ["TRAVIS_EVENT_TYPE"] == "cron":
        os.environ["ANACONDA_LABEL"] = "cron"
    else:
        os.environ["ANACONDA_LABEL"] = "main"

def set_docker_owner():
    if "DOCKER_LOGIN" in os.environ:
        os.environ["DOCKER_OWNER"] = os.environ["DOCKER_LOGIN"]

def set_docker_deploy():
    if "DOCKER_LOGIN" in os.environ and os.environ["TRAVIS_OS_NAME"] == "linux":
        os.environ["DOCKER_DEPLOY"] = os.environ["CI"]
    else:
        os.environ["DOCKER_DEPLOY"] = "false"

def set_docker_container():
    if "DOCKER_CONTEXT" in os.environ:
        os.environ["DOCKER_CONTAINER"] = os.path.basename(os.environ["DOCKER_CONTEXT"])

def set_travis_tag():
    os.environ["TRAVIS_TAG"] = "latest"

def set_jupyter_kernel():
    os.environ["JUPYTER_KERNEL"] = "python" + os.environ["CONDA_VERSION"]

def set_python_version():
    os.environ["PYTHON_VERSION"] = os.environ["CONDA_VERSION"]

def set_anaconda_force():
    if os.environ["ANACONDA_LABEL"] == "release" and os.environ["TRAVIS_BRANCH"] == "master":
        os.environ["ANACONDA_FORCE"] = "false"
    else:
        os.environ["ANACONDA_FORCE"] = "true"

def set_test_level():
    os.environ["TEST_LEVEL"] = "1"

def set_old_build_string():
    if os.environ["ANACONDA_FORCE"] == "true":
        os.environ["OLD_BUILD_STRING"] = "true"
    else:
        os.environ["OLD_BUILD_STRING"] = "false"    

def set_anaconda_tmp_label():
    if os.environ["ANACONDA_LABEL"] == "release":
        os.environ["ANACONDA_TMP_LABEL"] = os.environ["TRAVIS_OS_NAME"] + "-" + os.environ["ARCH"] + "_release"
        os.environ.pop("ANACONDA_LABEL")
        set_anaconda_label()
    else:
        os.environ["ANACONDA_TMP_LABEL"] = os.environ["ANACONDA_LABEL"]

def main():
    for var in ["TRAVIS_OS_NAME",
                "ARCH",
                "CONDA_VERSION",
                "ANACONDA_OWNER",
                "ANACONDA_DEPLOY",
                "ANACONDA_LABEL",
                "ANACONDA_RELEASE",
                "DOCKER_OWNER",
                "DOCKER_CONTAINER",
                "TRAVIS_TAG",
                "JUPYTER_KERNEL",
                "PYTHON_VERSION",
                "ANACONDA_FORCE",
                "TEST_LEVEL",
                "OLD_BUILD_STRING",
                "ANACONDA_TMP_LABEL"]:
        if not var in os.environ:
            exec("set_" + var.lower(), globals())
    if os.environ["ANACONDA_FORCE"] == "true":
        os.environ["ANACONDA_FORCE"] = "--force"
    else:
        os.environ["ANACONDA_FORCE"] = ""
    if os.environ["OLD_BUILD_STRING"] == "true":
        os.environ["OLD_BUILD_STRING"] = "--old-build-string"
    else:
        os.environ["OLD_BUILD_STRING"] = ""
    with open("configure.sh", "w") as filehandler:
        filehandler.write("set -ev\n\n")
        if six.PY2:
            for key, value in os.environ.iteritems():
                if key not in __PREV__ or not __PREV__[key] == os.environ[key]:
                    filehandler.write("export " + key + "=" + value + "\n")
        else:
            for key, value in os.environ.items():
                if key not in __PREV__ or not __PREV__[key] == os.environ[key]:
                    filehandler.write("export " + key + "=" + value + "\n")
        filehandler.write("\nset +ev")

if __name__ == "__main__":
    main()