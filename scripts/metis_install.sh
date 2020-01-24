#! /bin/sh
# compile metis

# tarball: metis-5.1.0.tar.gz from
# http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/metis-5.1.0.tar.gz
export METIS_VERSION=5.1.0

# ifort compiler and 64bit !!!
if [ ! -f `which ifort` ]; then
   echo 'Please use ifort settings first'
   exit 1
fi
CC=icc

# clean up any remaining targets
rm -rf metis_linux64_ifort
rm -rf metis-$METIS_VERSION
mkdir metis_linux64_ifort

# unpack tar-ball
tar -xzf metis-$METIS_VERSION.tar.gz
pushd metis-$METIS_VERSION

export BASE=$PWD

make config prefix=$PWD/../metis_linux64_ifort shared=1 cc=${CC}  2>&1 |tee myconfig.log

make 2>&1 | tee mymake.log

make install 2>&1 | tee mymake_install.log

popd

