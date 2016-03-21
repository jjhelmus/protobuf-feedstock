#!/bin/bash


if [ "$(uname)" == "Darwin" ];
then
    # Switch to clang with C++11 ASAP.
    export CC=gcc
    export CXX=g++
elif [ "$(uname)" == "Linux" ];
then
    export CC=gcc
    export CXX=g++
fi

# Doesn't include gmock or gtest. So, need to get these ourselves for `make check`.
git clone -b release-1.7.0 git://github.com/google/googlemock.git gmock
git clone -b release-1.7.0 git://github.com/google/googletest.git gmock/gtest

# Build configure/Makefile as they are not present.
aclocal
libtoolize
autoconf
autoreconf -i
automake --add-missing

./configure --prefix="${PREFIX}" \
	    CC="${CC}" \
	    CXX="${CXX}" \
	    CXXFLAGS="${CXXFLAGS}" \
	    LDFLAGS="${LDFLAGS}"
make
make check
make install
(cd python && python setup.py install --single-version-externally-managed --record record.txt && cd ..)
