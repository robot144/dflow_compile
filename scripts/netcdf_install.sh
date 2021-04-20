#! /bin/bash
#
# Compile netcdf libraries for linux or windows&mingw
#
# arguments:
#   ifort    : force ifort compiler
#   gnu      : force gfortran compiler
#   32       : force 32bit compilation
#   64       : force 64bit compilation
#   netcdf4  : include netcdf4 support
#   dap      : include opendap support
#
# Requirements: 
#
# On linux:
# - make sure you have the compilers you want to use (gcc gfortran/ifort) in the calling path
# - for dap: have curl installed or sources available in current directory (typically with your package manager)
# - for netcdf4: have zlib installed inluding the header files (typically with your package manager)
# On windows:
# - Install gnu compiler through mingw : 
#   http://sourceforge.net/projects/mingw/files/Installer/mingw-get-inst/
#   make sure to include msys in the installation (safest is to select install all components)
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
#default for netcdf4 support (=no)
export USENETCDF4="yes"
export USEDAP="no"
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
    netcdf4*)    USENETCDF4="yes"
            ;;
    dap*)    USEDAP="yes"
            ;;
    esac
done
#recheck compilers
if [ "$FORT" == "ifort" ];then
	export IFORTPATH=`which ifort 2>/dev/null`
	export FC=ifort
        export CC=icc
        export CXX=icpc
	if [ ! -z "$IFORTPATH" ]; then
		export MYFORT="$IFORTPATH"
	else
		echo "No ifort compiler found"
		exit 1
	fi
fi
if [ "$FORT" == "gnu" ];then
	export GFORTRANPATH=`which gfortran 2>/dev/null`
	export FC=gfortran
        export CC=gcc
        export CXX=g++
	if [ ! -z "$GFORTRANPATH" ]; then
		export MYFORT="$GFORTRANPATH"
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
# curl (for opendap and to download sources)
#
# http://curl.haxx.se/download/curl-7.25.0.tar.gz

#
# HDF5
# 
if [ "$USENETCDF4" == "yes" ]; then
        #https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/hdf5-1.10.1/src/hdf5-1.10.1.tar.gz
	export HDFVERSION='1.10.4'
	export HDFMAINVERSION='1.10'
	export HDFFILE="external_sources/hdf5-${HDFVERSION}.tar.gz"
	export HDFURL="https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-${HDFMAINVERSION}/hdf5-${HDFVERSION}/src/hdf5-${HDFVERSION}.tar.gz"
	if [ ! -f "$HDFFILE" ]; then
		echo "curl -o ${HDFFILE} ${HDFURL} "
		curl -o $HDFFILE $HDFURL
		if [ $? -gt 0 ]; then
			echo "could not download hdf"
			exit 1
		fi
	fi
	#
	# Here we assume the tarball is already there.
	#
	export EXTRACTDIR="$BASE/hdf5-$HDFVERSION"
	rm -rf $EXTRACTDIR
	tar -xzf $HDFFILE
	
	# compile in a temporary direcory to avoid mixing sources and objects
	export HDFTEMPDIR="hdf_${SYSTEM}_temp"
	rm -rf $HDFTEMPDIR
	mkdir $HDFTEMPDIR
	pushd $HDFTEMPDIR
	
	if [ "$ARCH" == "64" ]; then
		export archflag=""
	elif [ "$ARCH" == "32" ]; then
		export archflag="-m32"
		echo "linux32 currently not supported.  architecture ARCH=$ARCH"
                exit 1
	else
		echo "unknown architecture ARCH=$ARCH"
		exit 1
	fi
	$EXTRACTDIR/configure --prefix=$BASE/hdf_${SYSTEM} --libdir=$BASE/hdf_${SYSTEM}/lib  CFLAGS="-fPIC $archflag" CXXFLAGS="-fPIC $archflag" 
	make
	#make check #optional tests
	make install
	
	popd
fi

#
# NETCDF
#
#ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-c-4.7.4.tar.gz
export NETCDFVERSION='4.7.4'
export NETCDFFILE="external_sources/netcdf-c-${NETCDFVERSION}.tar.gz"
export NETCDFURL="ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-c-${NETCDFVERSION}.tar.gz"
if [ ! -f "$NETCDFFILE" ]; then
	curl -o "$NETCDFFILE"  "$NETCDFURL"
	if [ $? -gt 0 ]; then
		echo "could not download netcdf"
		exit 1
	fi
fi
#ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-fortran-4.5.3.tar.gz
export NETCDFFORTRANVERSION='4.5.3'
export NETCDFFORTRANFILE="external_sources/netcdf-fortran-${NETCDFFORTRANVERSION}.tar.gz"
echo "NETCDFFORTRANFILE = ${NETCDFFORTRANFILE}"
export NETCDFFORTRANURL="ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-fortran-${NETCDFFORTRANVERSION}.tar.gz"
if [ ! -f "${NETCDFFORTRANFILE}" ]; then
	echo "curl -o ${NETCDFFORTRANFILE}  ${NETCDFFORTRANURL}"
	curl -o "$NETCDFFORTRANFILE"  "$NETCDFFORTRANURL"
	if [ $? -gt 0 ]; then
		echo "could not download netcdf fortran"
		exit 1
	fi
fi

#
# Here we assume the tarball is already there.
#
export EXTRACTDIR="$BASE/netcdf-c-$NETCDFVERSION"
rm -rf $EXTRACTDIR
tar -xzf $NETCDFFILE


# compile in a temporary direcory to avoid mixing sources and objects
export TEMPDIR="netcdf_${SYSTEM}_temp"
rm -rf $TEMPDIR
mkdir $TEMPDIR
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
export NETCDF4FLAGS=""
export includedir=""
if [ "$USENETCDF4" == "yes" ]; then
	export NETCDF4FLAGS="--enable-netcdf4 "
	export LDFLAGS=" -L$BASE/hdf_${SYSTEM}/lib "
	export includedir=" -I $BASE/hdf_${SYSTEM}/include "
else 
	export NETCDF4FLAGS="--disable-netcdf4 "
fi
export DAPFLAGS=""
if [ "$USEDAP" == "yes" ]; then
	export DAPFLAGS="--enable-dap"
else 
	export DAPFLAGS="--disable-dap"
	#TODO??? --disable-cdmremote
fi
export sharedlibflag="--enable-shared"
if [ "$OSTYPE" == "win" ]; then
	sharedlibflag="--enable-shared --enable-dll"
	#sharedlibflag=""
fi
# install to dirs like linux32_ifort
# use lib also for 64bit
#WAS $EXTRACTDIR/configure --prefix=$BASE/netcdf_$SYSTEM --libdir=$BASE/netcdf_$SYSTEM/lib $NETCDF4FLAGS $DAPFLAGS $sharedlibflag --with-pic --disable-cxx FFLAGS="-fPIC $archflag" CFLAGS="-fPIC $archflag" CXXFLAGS="-fPIC $archflag" FCFLAGS="-fPIC $archflag" FC="$MYFORT"
#$EXTRACTDIR/configure --prefix=$BASE/netcdf_$SYSTEM --libdir=$BASE/netcdf_$SYSTEM/lib $NETCDF4FLAGS $DAPFLAGS $sharedlibflag --with-pic FFLAGS="-fPIC $archflag" CFLAGS="-fPIC $archflag" CXXFLAGS="-fPIC $archflag" FCFLAGS="-fPIC $archflag" FC="$MYFORT"
$EXTRACTDIR/configure --prefix=$BASE/netcdf_$SYSTEM --libdir=$BASE/netcdf_$SYSTEM/lib $NETCDF4FLAGS $DAPFLAGS $sharedlibflag LDFLAGS="$LDFLAGS" CFLAGS="$includedir"

make
#make check #optional tests
make install

popd

#
# copy hdf5 libs to netcdf and delete hdf dirs
#
if [ "$USENETCDF4" == "yes" ]; then
	if [ -d  $BASE/netcdf_$SYSTEM/lib ]; then
		rsync -ruav $BASE/hdf_${SYSTEM}/lib/ $BASE/netcdf_$SYSTEM/lib/
	else
		rsync -ruav $BASE/hdf_${SYSTEM}/lib/ $BASE/netcdf_$SYSTEM/lib64/
	fi
fi

#
# add fortran bindings
# 
export EXTRACTDIRF="$BASE/netcdf-fortran-$NETCDFFORTRANVERSION"
rm -rf $EXTRACTDIRF
tar -xzf $NETCDFFORTRANFILE

# compile in a temporary direcory to avoid mixing sources and objects
export TEMPDIRF="netcdf_fortran_${SYSTEM}_temp"
rm -rf $TEMPDIRF
mkdir $TEMPDIRF
pushd $TEMPDIRF


#
# NOTE: WORKAROUND for gfortran10 and netcdf-fortran-4.4.4
# 
#
#if [ $GCCVERSION == 10 ];then
#  FCFLAGS_ADD=" -fallow-argument-mismatch"
#  FFLAGS_ADD=" -fallow-argument-mismatch"
#fi

# use lib also for 64bit
export LD_LIBRARY_PATH=${BASE}/netcdf_${SYSTEM}/lib:$LD_LIBRARY_PATH
#$EXTRACTDIRF/configure --prefix=$BASE/netcdf_$SYSTEM --libdir=$BASE/netcdf_$SYSTEM/lib $NETCDF4FLAGS $DAPFLAGS $sharedlibflag --with-pic --disable-cxx FFLAGS="-fPIC $archflag" CFLAGS="-fPIC $archflag" CXXFLAGS="-fPIC $archflag" FCFLAGS="-fPIC $archflag" FC="$MYFORT"
#$EXTRACTDIRF/configure --prefix=$BASE/netcdf_$SYSTEM --libdir=$BASE/netcdf_$SYSTEM/lib --with-pic CPPFLAGS="-I${BASE}/netcdf_${SYSTEM}/include" LDFLAGS="-L${BASE}/netcdf_${SYSTEM}/lib" FFLAGS="-fPIC $archflag" CFLAGS="-fPIC $archflag" CXXFLAGS="-fPIC $archflag" FCFLAGS="-fPIC $archflag" FC="$MYFORT"
$EXTRACTDIRF/configure --prefix=$BASE/netcdf_$SYSTEM --libdir=$BASE/netcdf_$SYSTEM/lib --with-pic CPPFLAGS="-I${BASE}/netcdf_${SYSTEM}/include" LDFLAGS="-L${BASE}/netcdf_${SYSTEM}/lib" FFLAGS="-fPIC $archflag ${FFLAGS_ADD}" CFLAGS="-fPIC $archflag" CXXFLAGS="-fPIC $archflag" FCFLAGS="-fPIC $archflag ${FCFLAGS_ADD}" FC="$MYFORT"

make
#make check #optional tests
make install

popd

#
# give info
# 
echo ""
echo "============================================================================"
echo "The netcdf libs and tools were installed at $BASE/$SYSTEM."
echo "The other directories and files can be removed. To do this type:"
echo "rm -rf hdf5* *_temp *.tar.gz"
echo "============================================================================"
echo ""
