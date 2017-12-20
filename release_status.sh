set -ev

if [[ ! -f /usr/bin/node ]]; then
    sudo ln -s /usr/bin/nodejs /usr/bin/node
fi

npm install -g travis-status

set +ve
