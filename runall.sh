#! /bin/bash
#
# main compile script 
# requires one argument string like bare_centos7_intel18 or docker_suse15.1_gcc
export BASE=$PWD

allowed_args=("bare_suse15.1_gcc" "bare_centos7_intel18" "bare_centos7_gcc" "bare_centos6_gcc" "bare_centos6_intel18")

#
# check argument
#
if [ $# -lt 1 ]; then
	echo "This script needs an argument. Allowed values are:"
	for value in ${allowed_args[@]} ;do
		echo "$value"
	done
	exit 1
fi

found=F
for value in ${allowed_args[@]} ;do
	if [ "$value" == "$1" ] ;then
		found=T
	fi
done   
if [ "$found" == "F" ] ; then
	echo "$1 is not a valid argument. Allowed values are:"
	for value in ${allowed_args[@]} ;do
		echo "$value"
	done
	exit 1
fi

#SVN
if [ ! -f local.sh ]; then
   echo "Could not find local settings file local.sh"
   exit 1
fi
. ./local.sh
if [ -z "$SVNUSER" ];then
   echo "Please set SVNUSER in local.sh"
   exit 1
fi

# get parts from argument like bare_centos6_intel16 splitting on _
IFS='_' read -ra FIELDS <<< "$1"
export BUILDTYPE=${FIELDS[0]}
export PLATFORM=${FIELDS[1]}
export COMPILER=${FIELDS[2]}
echo " Build type is $BUILDTYPE"
echo " Platform is $PLATFORM"
echo " Compiler is $COMPILER"

# run platform specific settings
. "./settings/set_${PLATFORM}_${COMPILER}.sh"
echo "SETTINGS $SETTINGS" #debug output

# check if programs needed are there
# test for programs
programs=("make" "automake" "svn" "autoreconf" "libtool" "cmake")
for program in ${programs[@]} ;do
	temp=`which $program`
	if [ -z "$temp" ] ; then
		echo "Could not find $program"
		exit 1
	fi
done
if [ "$COMPILER" == "gcc" ];then
	export CC=`which gcc`
	if [ -z "$CC" ] ; then
		echo "Could not find gcc"
		exit 1
	fi
	export FC=`which gfortran`
	if [ -z "$FC" ] ; then
		echo "Could not find gfortran"
		exit 1
	fi
	export COMPILERTYPE="gnu"
else
	export CC=`which icc`
	if [ -z "$CC" ] ; then
		echo "Could not find icc"
		exit 1
	fi
	export FC=`which ifort`
	if [ -z "$FC" ] ; then
		echo "Could not find ifort"
		exit 1
	fi
	export COMPILERTYPE="ifort"
fi

## build mpi
if [ "$MPI_LOCAL" == "T" ]; then
   export MPIROOT=${BASE}/mpich_linux64_${COMPILERTYPE}
   if [ ! -d "${MPIROOT}" ]; then
      #./scripts/mpi_install.sh $COMPILERTYPE 64 noshared
      ./scripts/mpi_install.sh $COMPILERTYPE 64 shared
   fi
   export PATH=${MPIROOT}/bin:${PATH}
   export LD_LIBRARY_PATH=${MPIROOT}/lib:${LD_LIBRARY_PATH}
fi

## build NetCDF including NetCDF4 and fortran bindings
if [ "$NETCDF_LOCAL" == "T" ]; then
   export NETCDFROOT=${BASE}/netcdf_linux64_${COMPILERTYPE}
   if [ ! -d "${NETCDFROOT}" ]; then
      ./scripts/netcdf_install.sh $COMPILERTYPE 64 netcdf4
   fi
   export PATH=${NETCDFROOT}/bin:${PATH}
   export LD_LIBRARY_PATH=${NETCDFROOT}/lib:${LD_LIBRARY_PATH}
   export PKG_CONFIG_PATH=${NETCDFROOT}/lib/pkgconfig:${PKG_CONFIG_PATH}
fi

## build petsc
if [ "$PETSC_LOCAL" == "T" ]; then
   export PETSCROOT=${BASE}/petsc_linux64_${COMPILERTYPE}
   if [ ! -d "${PETSCROOT}" ]; then
      ./scripts/petsc_install.sh $COMPILERTYPE
   fi
   export PATH=${PETSCROOT}/bin:${PATH}
   export LD_LIBRARY_PATH=${PETSCROOT}/lib:${LD_LIBRARY_PATH}
   export PKG_CONFIG_PATH=${PETSCROOT}/lib/pkgconfig:${PKG_CONFIG_PATH}
fi

## build metis 
if [ "$METIS_LOCAL" == "T" ]; then
   export METISROOT=${BASE}/metis_linux64_${COMPILERTYPE}
   if [ ! -d "${METISROOT}" ]; then
      ./scripts/metis_install.sh $COMPILERTYPE
   fi
   export METIS_DIR=${METISROOT}
   export CPPFLAGS="-I${METISROOT}/include ${CPPFLAGS}"
   export LDFLAGS="-L ${METISROOT}/lib ${LDFLAGS}"
fi

## get dflow code from repos
if [ ! -d dflowfm-trunk ]; then
   ./scripts/dflowfm_checkout.sh
else #clean if not a fresh checkout
   pushd dflowfm-trunk/src
   make clean
   popd
fi

## Finally build Delft3D includig DFLOW itself
export DFLOWFMROOT=${BASE}/dflowfm_linux64_${COMPILERTYPE}
if [ ! -d "${DFLOWFMROOT}" ]; then
   ./scripts/dflowfm_compile.sh $COMPILERTYPE
   #Copy intel runtime libs to target in case of ifort
   if [ "$COMPILERTYPE" == "ifort" ] ; then
      ./scripts/copylibs_intel.sh
   fi
   ./scripts/copy_files.sh #add files needed to run as stand-alone package
fi
# ./scripts/copy_files.sh #add files needed to run as stand-alone package



