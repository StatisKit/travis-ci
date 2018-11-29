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

def get_python_version():
    return str(sys.version_info[0]) + "." + str(sys.version_info[1])

def main():
    if not environ['PYTHON_VERSION'].count('.') == 1 or environ['PYTHON_VERSION'].endswith('.x'):
        environ["PYTHON_VERSION"] = get_python_version()
    if environ["TRAVIS_OS_NAME"] == "windows":
        with open("python_version.bat", "w") as filehandler:
            filehandler.write("echo ON\n\n")
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
            filehandler.write("\necho OFF")
    else:
        with open("python_version.sh", "w") as filehandler:
            filehandler.write("set -ex\n\n")
            if PY2:
                for key, value in environ.iteritems():
                    if key not in os.environ or not os.environ[key] == environ[key]:
                        filehandler.write("export " + key + "=\"" + value.strip() + "\"\n")
            else:
                for key, value in environ.items():
                    if key not in os.environ or not os.environ[key] == environ[key]:
                        filehandler.write("export " + key + "=\"" + value.strip() + "\"\n")
            filehandler.write("\nset +ex")

if __name__ == "__main__":
    main()