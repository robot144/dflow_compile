#! /bin/bash
#
# main compile script 
# requires one argument string like bare_centos7_intel18 or docker_suse15.1_gcc

allowed_args=("bare_suse15.1_gcc" "bare_centos7_intel18" "bare_centos7_gnu")

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
programs=("make" "automake" "svn" "autoreconf" "libtool")
for program in ${programs[@]} ;do
	temp=`which $program`
	if [ -z "$temp" ] ; then
		echo "Could not find $program"
		exit 1
	fi
done
if [ "$COMPILER" == "gcc" ];then
	temp=`which gcc`
	if [ -z "$temp" ] ; then
		echo "Could not find gcc"
		exit 1
	fi
	temp=`which gfortran`
	if [ -z "$temp" ] ; then
		echo "Could not find gfortran"
		exit 1
	fi
else
	temp=`which icc`
	if [ -z "$temp" ] ; then
		echo "Could not find icc"
		exit 1
	fi
	temp=`which ifort`
	if [ -z "$temp" ] ; then
		echo "Could not find ifort"
		exit 1
	fi
fi

# get dflow code from repos
./scripts/dflowfm_checkout.sh

#./mpi_install.sh ifort 64 noshared

#./netcdf_install.sh ifort 64 netcdf4

#./petsc_install.sh

#./metis_install.sh

#./dflowfm_compile_trunk_intel18.sh
