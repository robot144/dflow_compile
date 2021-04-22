#! /bin/bash
#Compile delft3d source including dflow

pushd dflowfm-trunk/src

#TODO No proj and shapelib for now. Do we want that?
export PROJ_CPPFLAGS=""
export PROJ_LDFLAGS=""
export PROJ_CONFARGS=""
export SHAPELIB_CPPFLAGS=""
export SHAPELIB_LDFLAGS=""
export SHAPELIB_CONFARGS=""

#
# autogen
#
export RUN_AUTOGEN=1
if [ ${RUN_AUTOGEN} -ne 0 ];then
   if [ -f Makefile.in ];then
      make clean
   fi
   ./autogen.sh --verbose 2>&1 |tee myautogen.log
   pushd third_party_open/kdtree2/
   ./autogen.sh --verbose 2>&1 |tee ../../myautogen_kdtree.log
   popd
fi

#
# configure
#
export log="$PWD/myconfig.log"
command=" \
    CPPFLAGS='$PROJ_CPPFLAGS $SHAPELIB_CPPFLAGS' \
    LDFLAGS='$lflags $LDFLAGS $PROJ_LDFLAGS $SHAPELIB_LDFLAGS' \
    CFLAGS='$flags $CFLAGS' \
    CXXFLAGS='$flags $CXXFLAGS' \
    AM_FFLAGS='$LDFLAGSMT_ADDITIONAL $AM_FFLAGS' \
    FFLAGS='$flags $fflags $FFLAGS' \
    AM_FCFLAGS='$LDFLAGSMT_ADDITIONAL $AM_FCFLAGS' \
    FCFLAGS='$flags $fflags $FCFLAGS' \
    AM_LDFLAGS='$LDFLAGSMT_ADDITIONAL $AM_LDFLAGS' \
        ./configure --prefix=${DFLOWFMROOT} --libdir=${DFLOWFMROOT}/lib  --with-mpi --with-petsc --with-metis=$METIS_DIR $PROJ_CONFARGS $SHAPELIB_CONFARGS $configureArgs 2>&1 |tee $log \
    "

eval $command

if [ $? -ne 0 ]; then
    echo "ERROR: Configure fails!"
    echo "Log can be found in: $log"
    popd
    exit 1
fi

#
# WORKAROUND
#
# NOTE: switched of SWAN alltogether for now.
# copy sources to build swan multiple times
#cp third_party_open/swan/src/*.f* third_party_open/swan/swan_mpi
#cp third_party_open/swan/src/*.F* third_party_open/swan/swan_mpi
#cp third_party_open/swan/src/*.f* third_party_open/swan/swan_omp
#cp third_party_open/swan/src/*.F* third_party_open/swan/swan_omp


#
# make delft3d
#
export COMPILE_D3D=1 # 0 = true
if [ $COMPILE_D3D -ne 0 ];then
   export log="$PWD/mymake_delft3d.log"
   command="FC=mpif90 make ds-install 2>&1 |tee $log"

   echo "Start compilation of Delft3D and tools"
   eval $command

   if [ $? -ne 0 ]; then #This does not seem to work!
       echo "ERROR: Make delft3d fails!"
       echo "Log can be found in: $log"
       popd
       exit 1
   else
       echo "Make delft3d succeeded."
   fi
fi

#
# make delft3d-fm
#
export COMPILE_DFLOW=1 # 1 = true
if [ $COMPILE_DFLOW -ne 0 ];then
   export log="$PWD/mymake_dflow.log"
   command="FC=mpif90 make ds-install -C engines_gpl/dflowfm 2>&1 |tee $log"

   echo "Start compilation of Dflow (Delft3D-FM)"
   eval $command
   
   if [ $? -ne 0 ]; then
       echo "ERROR: Make dflow fails!"
       echo "Log can be found in: $log"
       popd
       exit 1
   else
       echo "Make dflowfm succeeded."
   fi
fi




popd
