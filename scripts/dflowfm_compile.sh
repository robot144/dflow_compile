#! /bin/bash
#Compile delft3d source including dflow

pushd dflowfm-trunk/src

#TODO No proj and shapelib for now
export PROJ_CPPFLAGS=""
export PROJ_LDFLAGS=""
export PROJ_CONFARGS=""
export SHAPELIB_CPPFLAGS=""
export SHAPELIB_LDFLAGS=""
export SHAPELIB_CONFARGS=""

#
# autogen
#
./autogen.sh --verbose 2>&1 |tee myautogen.log
pushd third_party_open/kdtree2/
./autogen.sh --verbose 2>&1 |tee ../../myautogen_kdtree.log
popd

#
# configure
#
export log="$PWD/myconfig.log"
command=" \
    CPPFLAGS='$PROJ_CPPFLAGS $SHAPELIB_CPPFLAGS' \
    LDFLAGS='$PROJ_LDFLAGS $SHAPELIB_LDFLAGS' \
    CFLAGS='$flags $CFLAGS' \
    CXXFLAGS='$flags $CXXFLAGS' \
    AM_FFLAGS='$LDFLAGSMT_ADDITIONAL $AM_FFLAGS' \
    FFLAGS='$flags $fflags $FFLAGS' \
    AM_FCFLAGS='$LDFLAGSMT_ADDITIONAL $AM_FCFLAGS' \
    FCFLAGS='$flags $fflags $FCFLAGS' \
    AM_LDFLAGS='$LDFLAGSMT_ADDITIONAL $AM_LDFLAGS' \
        ./configure --prefix=${DFLOWFMROOT} --with-mpi --with-petsc --with-metis=$METIS_DIR $PROJ_CONFARGS $SHAPELIB_CONFARGS $configureArgs 2>&1 |tee $log \
    "

eval $command

if [ $? -ne 0 ]; then
    echo "ERROR: Configure fails!"
    echo "Log can be found in: $log"
    popd
    exit 1
fi

#
# make delft3d
#
export log="$PWD/mymake_delft3d.log"
command="FC=mpif90 make ds-install 2>&1 |tee $log"
eval $command

if [ $? -ne 0 ]; then
    echo "ERROR: Make delft3d fails!"
    echo "Log can be found in: $log"
    popd
    exit 1
fi

#
# make delft3d-fm
#
export log="$PWD/mymake_dflow.log"
command="FC=mpif90 make ds-install -C engines_gpl/dflowfm 2>&1 |tee $log"

eval $command

if [ $? -ne 0 ]; then
    echo "ERROR: Make dflow fails!"
    echo "Log can be found in: $log"
    popd
    exit 1
fi




popd
