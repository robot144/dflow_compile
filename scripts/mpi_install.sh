#! /bin/bash
#
# Compile mpich libraries for linux or windows&mingw
#
# arguments:
#   ifort    : force ifort compiler
#   gnu      : force gfortran compiler
#   32       : force 32bit compilation
#   64       : force 64bit compilation
#   shared   : create shared libs
#   noshared : do not create shared libs
#
# Defaults
# ifort (if found in path) 64 noshared
# Requirements: 
#
# On linux:
# - make sure you have the compilers you want to use (gcc gfortran/ifort) in the calling path
# On windows:
#   NOT TESTED!!!
#

#
#=============================================================================================================
#
#defaults for fortran compiler (=prefer ifort over gfortran)
export FORT=""
hash ifort >/dev/null 2>&1
if [ $? -eq 0 ]; then
	FORT=ifort
else 
	hash gfortran >/dev/null 2>&1
	if [ $? -eq 0 ]; then
		FORT=gnu
	else
		echo "No fortran compiler found"
		return 1
        fi
fi	
#defaults for 64/32bit (=look at architecture of this computer)
export RAWARCH=`uname -m`
if [ "$RAWARCH" == "x86_64" ]; then
   export ARCH=64
else
   export ARCH=32
fi
#default for shared-libs support
export USESHARED="no"

#test for windows mingw
export OSTYPE="unknown"
export TMPVAR=`uname -s|grep -i mingw`
if [ ! -z  "$TMPVAR" ]; then
	OSTYPE="win"
fi
export TMPVAR=`uname -s|grep -i linux`
if [ ! -z  "$TMPVAR" ]; then
	OSTYPE="linux"
fi

# parse arguments
for arg in "$@"
do
    case "$arg" in
    64*)    ARCH="64"
            ;;
    32*)    ARCH="32"
            ;;
    ifort*)    FORT="ifort"
            ;;
    gnu*)    FORT="gnu"
            ;;
    shared*)    USESHARED="yes"
            ;;
    noshared*)    USESHARED="no"
            ;;
    esac
done
#recheck compilers
if [ "$FORT" == "ifort" ];then
	export IFORTPATH=`which ifort 2>/dev/null`
	if [ ! -z "$IFORTPATH" ]; then
		export MYFORT="ifort"
	        export ICCPATH=`which icc 2>/dev/null`
		export MYCC="icc"
	        export ICPCPATH=`which icpc 2>/dev/null`
		export MYCXX="icpc"
	else
		echo "No ifort compiler found"
		exit 1
	fi
fi
if [ "$FORT" == "gnu" ];then
	export GFORTRANPATH=`which gfortran 2>/dev/null`
	if [ ! -z "$GFORTRANPATH" ]; then
		export MYFORT="$GFORTRANPATH"
	        export GCCPATH=`which gcc 2>/dev/null`
		export MYCC="$GCCPATH"
	        export GXXPATH=`which g++ 2>/dev/null`
		export MYCXX="$GXXPATH"
	else
		echo "No gfortran compiler found"
		exit 1
	fi
fi

export SYSTEM="${OSTYPE}${ARCH}_${FORT}"
echo "Architecture OS=$OSTYPE ARCH=$ARCH on system RAWARCH=$RAWARCH"
echo "Fortran compiler FORT=$FORT"
echo "path to compiler is MYFORT=$MYFORT"
echo "SYSTEM=$SYSTEM"
export BASE=$PWD
#
#=============================================================================================================
#


#
# MPICH
#
export MPIVERSION='3.3.1'
export EXTRACTDIR="$BASE/mpich-$MPIVERSION"
export MPIFILE="external_sources/mpich-${MPIVERSION}.tar.gz"
# http://www.mpich.org/static/downloads/3.3.1/mpich-3.3.1.tar.gz
export MPIURL="http://www.mpich.org/static/downloads/$MPIVERSION/mpich-$MPIVERSION.tar.gz"
if [ ! -f "$MPIFILE" ]; then
	curl -o "$MPIFILE"  "$MPIURL"
	if [ $? -gt 0 ]; then
		echo "could not download mpich"
		exit 1
	fi
fi

if [ -z "${MPIROOT}" ]; then
   export MPIROOT="${BASE}/mpich_linux64_${FORT}"
fi

#
# Here we assume the tarball is already there.
#
export EXTRACTDIR="$BASE/mpich-$MPIVERSION"
rm -rf $EXTRACTDIR
tar -xzf $MPIFILE


# compile in a temporary direcory to avoid mixing sources and objects
export TEMPDIR="mpich_${SYSTEM}_temp"
rm -rf $TEMPDIR
mkdir $TEMPDIR
#TODO workaround for out source build
rsync -rua ${EXTRACTDIR}/ ${TEMPDIR}
pushd $TEMPDIR


# we are going to build a shared library later so the option -fPIC is needed and
# --enable-shared triggers this option.
if [ "$ARCH" == "64" ]; then
	export archflag=""
elif [ "$ARCH" == "32" ]; then
	export archflag="-m32"
else
	echo "unknown architecture ARCH=$ARCH"
	exit 1
fi

export SHAREDFLAGS=""
if [ "$USESHARED" == "yes" ]; then
	export SHAREDFLAGS="--enable-shared"
	if [ "$OSTYPE" == "win" ]; then
		export SHAREDFLAGS="--enable-shared --enable-dll"
	fi
else 
	export SHAREDFLAGS="--disable-shared"
fi
# install to dirs like linux32_ifort
# use lib also for 64bit
#$EXTRACTDIR/configure --prefix=$BASE/mpich_$SYSTEM --libdir=$BASE/mpich_$SYSTEM/lib $SHAREDFLAGS --enable-cxx FFLAGS="-fPIC $archflag" CFLAGS="-fPIC $archflag" CXXFLAGS="-fPIC $archflag" FCFLAGS="-fPIC $archflag" FC="$MYFORT" F77="$MYFORT"
#TODO workaround for out of source build
#./configure --prefix=${MPIROOT} --libdir=${MPIROOT}/lib $SHAREDFLAGS --enable-cxx FFLAGS="-fPIC $archflag" CFLAGS="-fPIC $archflag" CXXFLAGS="-fPIC $archflag" FCFLAGS="-fPIC $archflag" FC="$MYFORT" F77="$MYFORT" CC="$MYCC" CXX="$MYCXX"
# try with shared libs
#./configure --prefix=${MPIROOT} --libdir=${MPIROOT}/lib $SHAREDFLAGS --enable-cxx FFLAGS=" $archflag" CFLAGS=" $archflag" CXXFLAGS=" $archflag" FCFLAGS=" $archflag" FC="$MYFORT" F77="$MYFORT" CC="$MYCC" CXX="$MYCXX"
./configure --prefix=${MPIROOT} --libdir=${MPIROOT}/lib --enable-cxx FC="$MYFORT" F77="$MYFORT" CC="$MYCC" CXX="$MYCXX"

make
#make check #optional tests
make install

popd

#
# give info
# 
echo ""
echo "============================================================================"
echo "The mpi libs and tools were installed at $BASE/$SYSTEM."
echo "The other directories and files can be removed. To do this type:"
echo "rm -rf  *_temp *.tar.gz"
echo "============================================================================"
echo ""
