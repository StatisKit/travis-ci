import os
import shutil
import platform
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

def get_travis_os_name():
    SYSTEM = platform.system() 
    if SYSTEM == "Linux":
        SYSTEM = "linux"
    elif SYSTEM == "Darwin":
        SYSTEM = "osx"
    elif SYSTEM == "Windows":
        SYSTEM = "windows"
    else:
        raise NotImplementedError("Travis CI is not meant for '" + SYSTEM + "' operating systems")
    return SYSTEM

def get_travis_event_type():
    return "api"

def get_travis_branch():
    return "master"

def get_ci():
    return "false"

def get_arch():
    if sys.maxsize > 2**32:
        return "x86_64"
    else:
        return "x86"

def get_conda_version():
    if "PYTHON_VERSION" in environ:
        return environ["PYTHON_VERSION"].split(".")[0]
    else:
        return "3"

def get_anaconda_owner():
    if "ANACONDA_LOGIN" in environ:
        return environ["ANACONDA_LOGIN"]

def get_anaconda_deploy():
    return environ["CI"]

def get_anaconda_release():
    return "false"

def get_anaconda_label():
    if "TRAVIS_EVENT_TYPE" in environ and environ["TRAVIS_EVENT_TYPE"] == "cron":
        return "cron"
    else:
        return "develop"

def get_docker_owner():
    if "DOCKER_LOGIN" in environ:
        return environ["DOCKER_LOGIN"]

def get_docker_deploy():
    if "DOCKER_LOGIN" in environ and environ["TRAVIS_OS_NAME"] == "linux":
        return environ["CI"]
    else:
        return "false"

def get_docker_container():
    if "DOCKER_CONTEXT" in environ:
        return os.path.basename(environ["DOCKER_CONTEXT"])

def get_travis_tag():
    return "latest"

def get_jupyter_kernel():
    return "python" + environ["CONDA_VERSION"]

def get_python_version():
    return environ["CONDA_VERSION"]

def get_anaconda_force():
    if environ["ANACONDA_LABEL"] == "release" and environ["TRAVIS_BRANCH"] == "master":
        return "false"
    else:
        return "true"

def get_test_level():
    if environ["CI"] == "true":
        return "1"
    else:
        return "3"

def get_old_build_string():
    return "true"
    
def get_anaconda_tmp_label():
    if environ["ANACONDA_LABEL"] == "release":
        return environ["TRAVIS_OS_NAME"] + "-" + environ["ARCH"] + "_release"
    else:
        return environ["ANACONDA_LABEL"]

def get_conda_prefix():
    return "${HOME}/miniconda"
    
def get_conda_feature():
    if environ['ANACONDA_FORCE'] == "true":
        return "unstable"
    else:
        return "stable"

def get_travis_commit_message():
    return ""

def get_travis_skip():
    if environ["TRAVIS_OS_NAME"] == "windows":
        if "[skip win]" in environ["TRAVIS_COMMIT_MESSAGE"] or "[win skip]" in environ["TRAVIS_COMMIT_MESSAGE"]:
            return "true"
        else:
            return "false"
    else:
        if "[skip unix]" in environ["TRAVIS_COMMIT_MESSAGE"] or "[unix skip]" in environ["TRAVIS_COMMIT_MESSAGE"]:
            return "true"
        elif environ["TRAVIS_OS_NAME"] == "osx":
            if "[skip osx]" in environ["TRAVIS_COMMIT_MESSAGE"] or "[osx skip]" in environ["TRAVIS_COMMIT_MESSAGE"]:
                return "true"
            else:
                return "false"
        else:
            if "[skip linux]" in environ["TRAVIS_COMMIT_MESSAGE"] or "[linux skip]" in environ["TRAVIS_COMMIT_MESSAGE"]:
                return "true"
            else:
                return "false"            

def main():
    for key in ["TRAVIS_OS_NAME",
                "TRAVIS_EVENT_TYPE",
                "TRAVIS_BRANCH",
                "CI",
                "ARCH",
                "CONDA_VERSION",
                "ANACONDA_LABEL",
                "ANACONDA_OWNER",
                "ANACONDA_DEPLOY",
                "ANACONDA_RELEASE",
                "DOCKER_OWNER",
                "DOCKER_CONTAINER",
                "TRAVIS_TAG",
                "JUPYTER_KERNEL",
                "PYTHON_VERSION",
                "ANACONDA_FORCE", 
                "TEST_LEVEL",
                "OLD_BUILD_STRING",
                "ANACONDA_TMP_LABEL",
                "CONDA_PREFIX",
                "CONDA_FEATURE",
                "TRAVIS_COMMIT_MESSAGE",
                "TRAVIS_SKIP"]:
        if key not in environ:
            value = eval("get_" + key.lower() + "()")
            if value:
                environ[key] = value
    ANACONDA_CHANNELS = []
    if "ANACONDA_OWNER" in environ:
        ANACONDA_CHANNELS.append(environ["ANACONDA_OWNER"])
        if not environ["ANACONDA_LABEL"] == "main":
            if not environ["ANACONDA_LABEL"] == "develop":
                ANACONDA_CHANNELS.append(environ["ANACONDA_OWNER"] + "/label/develop")
            ANACONDA_CHANNELS.append(environ["ANACONDA_OWNER"] + "/label/" + environ["ANACONDA_LABEL"])
        if not environ["ANACONDA_TMP_LABEL"] == environ["ANACONDA_LABEL"]:
            ANACONDA_CHANNELS.append(environ["ANACONDA_OWNER"] + "/label/" + environ["ANACONDA_TMP_LABEL"])
    environ["ANACONDA_CHANNELS"] = ""
    for ANACONDA_CHANNEL in list(reversed(environ.get("ANACONDA_CHANNELS", "").split(" "))) + ANACONDA_CHANNELS:
        if ANACONDA_CHANNEL:
            environ["ANACONDA_CHANNELS"] += " --add channels " + ANACONDA_CHANNEL
    if environ["ANACONDA_LABEL"] == "release":
        if environ["TRAVIS_EVENT_TYPE"] == "cron":
            environ["ANACONDA_LABEL"] = "cron"
        else:
            environ["ANACONDA_LABEL"] = "main"
    if environ["ANACONDA_FORCE"] == "true":
        environ["ANACONDA_FORCE"] = "--force"
    else:
        environ["ANACONDA_FORCE"] = ""
    if environ["OLD_BUILD_STRING"] == "true":
        environ["OLD_BUILD_STRING"] = "--old-build-string"
    else:
        environ["OLD_BUILD_STRING"] = ""
    if environ["TRAVIS_OS_NAME"] == "windows":
        with open("environ.bat", "w") as filehandler:
            if PY2:
                for key, value in environ.iteritems():
                    if key not in os.environ or not os.environ[key] == environ[key]:
                        filehandler.write("set " + key + "=" + value.strip() + "\n")
                        filehandler.write("if errorlevel 1 exit 1\n")
            else:
                for key, value in environ.items():
                    if key not in os.environ or not os.environ[key] == environ[key]:
                        filehandler.write("set " + key + "=" + value.strip() + "\n")
                        filehandler.write("if errorlevel 1 exit 1\n")
            filehandler.write("set PATH=%CONDA_PREFIX%;%CONDA_PREFIX%\\Scripts;%PATH%\n")
            filehandler.write("if \"%TRAVIS_SKIP%\" == \"true\" (\n  exit 0\n)\n")
    else:
        with open("environ.sh", "w") as filehandler:
            if PY2:
                for key, value in environ.iteritems():
                    if key not in os.environ or not os.environ[key] == environ[key]:
                        filehandler.write("export " + key + "=\"" + value.strip() + "\"\n")
            else:
                for key, value in environ.items():
                    if key not in os.environ or not os.environ[key] == environ[key]:
                        filehandler.write("export " + key + "=\"" + value.strip() + "\"\n")
            if environ["TRAVIS_OS_NAME"] == "linux":
                filehandler.write("set -x\nexport PS1='$ '\necho source ${HOME}/.bashrc\nsource ${HOME}/.bashrc\nset -x\n")
            else:
                filehandler.write("set +e\nsource ${HOME}/.bash_profile\nset -e\n")
                # filehandler.write("set +x\necho source ${HOME}/.bash_profile\nsource ${HOME}/.bash_profile\nset -x\n")
            filehandler.write("if [[ \"${TRAVIS_SKIP}\" = \"true\" ]]; then\n  exit 0\nfi\n")
        if PY2:
            os.chmod("environ.sh", 0o755) 
        else:
            os.chmod("environ.sh", 0o755) 

if __name__ == "__main__":
    main()