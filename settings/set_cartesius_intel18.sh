#! /bin/sh
# Settings for surfsara.nl Cartesius with Intel2018b compilation of dflow

echo "Settings for Cartesius with Intel 18 compiler"

module load 2019
module load intel/2018b

#Build tools on by default, so modules below unchecked
#module load autoconf
#module load automake
#module load libtool
#module load subversion


#MPICH
export MPI_LOCAL=F
if [ "${MPI_LOCAL}" == "F" ]; then
   echo "Using intel MPI"
else
   echo "Building local MPICH"
fi

#NETCDF
export NETCDF_LOCAL=F
if [ "${NETCDF_LOCAL}" == "F" ]; then
   module load netCDF/4.6.1-intel-2018b
   module load netCDF-Fortran/4.4.4-intel-2018b
   export NETCDFROOT=${EBROOTNETCDF}
   echo "NETCDFROOT = ${NETCDFROOT}"
else
   echo "Building local NetCDF"
fi

#PETSC
export PETSC_LOCAL=F
if [ "${PETSC_LOCAL}" == "F" ]; then
   module load PETSc/3.11.2-intel-2018b
   export PETSCROOT=${EBROOTPETSC}
   echo "PETSCROOT = ${PETSCROOT}"
else
   echo "Building local PETSC"
fi

#METIS systerm
export METIS_LOCAL=F
if [ "${METIS_LOCAL}" == "F" ]; then
   module load METIS/5.1.0-intel-2018b ParMETIS/4.0.3-intel-2018b
   export METISROOT=${EBROOTPARMETIS}
   echo "METISROOT = ${METISROOT}"
else
   echo "Building local Metis"
fi

module unload compilerwrappers

export FC=mpiifort
export F77=mpiifort
export CC=mpiicc
export CXX=mpiicpc
export MPICXX=mpiicpc
export MPICC=mpiicc
export MPIFC=mpiifort
export MPIF77=mpiifort

#overrule compiler options
echo "Ignoring existing compiler flags: ${flags}"
export flags="-O3 -xAVX -axAVX2" #used by Maxime (faster?)
echo "New compiler flags are: ${flags}"
export SETTINGS=T
