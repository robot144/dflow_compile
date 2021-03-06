#! /bin/sh
# Settings for ubuntu19 with intel20 compilation of dflow

<<<<<<< HEAD
echo "Settings for ubuntu 19 with intel 20 compiler"
=======
echo "Settings for Ubuntu 19 with Intel 20 compiler"
>>>>>>> a5cff1bc9f1b6042a2151e0a06ff79d0c4c9ef77

# Intel 20 compiler
. /opt64/intel/bin/compilervars.sh -arch intel64 -platform linux 
#export LD_LIBRARY_PATH=/opt64/...
export IFORTLIB=/opt64/intel/compilers_and_libraries/linux/lib/intel64

## build tools from ubuntu
#module load autoconf
#module load automake
#module load libtool

#subversion from ubuntu


#MPICH
export MPI_LOCAL=T
if [ "${MPI_LOCAL}" == "F" ]; then
   echo "No pre-compiled MPICH here."
   exit 1
   module load mpich2/3.3_intel_18.0.3
   export MPIROOT=/opt/mpich2/3.3_intel18.0.3
   echo "MPIROOT = ${MPIROOT}"
else
   echo "Building local MPICH"
fi

#NETCDF
export NETCDF_LOCAL=T
if [ "${NETCDF_LOCAL}" == "F" ]; then
   echo "No pre-compiled NETCDF here."
   exit 1
   module load netcdf/v4.6.2_v4.4.4_intel_18.0.3
   export NETCDFROOT=/opt/netcdf/v4.6.2_v4.4.4_intel_18.0.3
   echo "NETCDFROOT = ${NETCDFROOT}"
else
   echo "Building local NetCDF"
fi

#PETSC
export PETSC_LOCAL=T
if [ "${PETSC_LOCAL}" == "F" ]; then
   echo "No pre-compiled PETSC here."
   exit 1
   module load petsc/3.9.3_intel18.0.3_mpich_3.3
   export PETSCROOT=/opt/petsc/with_mpich_3.3/3.9.3_intel18.0.3
   echo "PETSCROOT = ${PETSCROOT}"
else
   echo "Building local PETSC"
fi

#METIS systerm
export METIS_LOCAL=T
if [ "$METIS_LOCAL}" == "F" ]; then
   echo "No pre-compiled METIS here."
   exit 1
   module load metis/5.1.0_intel18.0.3
   export METISROOT=/opt/metis/5.1.0_intel18.0.3
   echo "METISROOT = ${METISROOT}"
else
   echo "Building local Metis"
fi

export SETTINGS=T
