#!/bin/bash

set -e -x

if [ "${TRAVIS_OS_NAME}" == "osx" ]; then
    PYENV_ROOT="$HOME/.pyenv"
    PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
fi

make test && make bench && make cover

if [ "${COVERALLS}" == "yes" ]; then
    python setup.py test --coveralls;
fi
