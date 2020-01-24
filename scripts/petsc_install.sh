#! /bin/sh
# compile petsc

export PETSC_VERSION=3.9.4
export BASE=$PWD

# download tgz if not already there
#http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-3.9.4.tar.gz
export EXTRACTDIR="$BASE/petsc-$PETSC_VERSION"
export PETSC_FILE="petsc-${PETSC_VERSION}.tar.gz"
export PETSC_URL="http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-${PETSC_VERSION}.tar.gz"
if [ ! -f "$PETSC_FILE" ]; then
        curl -o "$PETSC_FILE"  "$PETSC_URL"
        if [ $? -gt 0 ]; then
                echo "could not download petsc"
                exit 1
        fi
fi


# clean up any remaining targets
rm -rf petsc_linux64_ifort
rm -rf petsc-$PETSC_VERSION

# unpack tar-ball
tar -xzvf petsc-$PETSC_VERSION.tar.gz
pushd petsc-$PETSC_VERSION

#mpi
export MPI_ROOT=${BASE}/../mpich_linux64_ifort
export MPI_LIBS="-L${MPI_ROOT}/lib -lmpich -lpthread -lrt -i-static"
export MPI_RSH="ssh"
export PATH=$MPI_ROOT/bin:$PATH
export LD_LIBRARY_PATH=$MPI_ROOT/lib:$LD_LIBRARY_PATH
#this should not be needed, but is for now
export LDFLAGS="-L$MPI_ROOT/lib"

#removed -xHOST from FOPTFLAGS
# removed -no-prec-div from FOPTFLAGS
./configure --prefix=$PWD/../petsc_linux64_ifort --with-mpi=1 --with-mpi-dir=$PWD/../mpich_linux64_ifort  \
  --download-fblaslapack=1 --FOPTFLAGS="-O3 " --CXXOPTFLAGS="-O3 "\
  --with-debugging=0 --with-shared-libraries=1 --with-x=0 --with-valgrind=0 --COPTFLAGS="-O3 " 
# --with-pthread=0 ??? also available for /opt

make 2>&1 >mymake.log

make install 2>&1 >mymake_install.log

popd
