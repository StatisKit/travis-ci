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
    with open("python_version.sh", "w") as filehandler:
        filehandler.write("set -ve\n\n")
        if PY2:
            for key, value in environ.iteritems():
                if key not in os.environ or not os.environ[key] == environ[key]:
                    filehandler.write("export " + key + "=\"" + value.strip() + "\"\n")
        else:
            for key, value in environ.items():
                if key not in os.environ or not os.environ[key] == environ[key]:
                    filehandler.write("export " + key + "=\"" + value.strip() + "\"\n")
        filehandler.write("\nset +ve")

if __name__ == "__main__":
    main()