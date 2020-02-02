#! /bin/sh
# compile metis
# argument gnu or ifort

#
# check argument
#
if [ $# -lt 1 ]; then
        echo "This script needs an argument. Allowed values are: gnu or ifort"
	exit 1
fi
export COMPILERTYPE=$1 
echo "COMPILERTYPE $COMPILERTYPE"

if [ -z "${METISROOT}" ]; then
   export BASE=$PWD
   export METISROOT=${BASE}/metis_linux64_${COMPILERTYPE}
fi

# tarball: metis-5.1.0.tar.gz from
# http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/metis-5.1.0.tar.gz
export METIS_VERSION=5.1.0

# Compiler selection
echo "CC before modification ${CC}"
if [ "$COMPILERTYPE" ==  "ifort" ]; then
	echo "Using ifort"
	CC=icc
elif [ "$COMPILERTYPE" == "gnu" ]; then
	CC=gcc
else
	echo "Wrong argument for metis_install.sh Valid are ifort and gnu"
	exit 1
fi

# clean up any remaining targets
rm -rf metis_linux64_${COMPILERTYPE}
rm -rf metis-$METIS_VERSION
mkdir metis_linux64_${COMPILERTYPE}

# unpack tar-ball
tar -xzf external_sources/metis-$METIS_VERSION.tar.gz
pushd metis-$METIS_VERSION


make config prefix=${METISROOT} shared=1 cc=${CC}  2>&1 |tee myconfig.log

make 2>&1 | tee mymake.log

make install 2>&1 | tee mymake_install.log

popd

