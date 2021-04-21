#! /bin/sh
# Settings for Ubuntu 20 with gfortran 10

echo "Settings for ubuntu 20.10 with gcc 10.2.0 compiler"

# gcc compiler 10.2.0 from ubuntu
#export GCCROOT=/opt/gcc/4.9.2
export GCCVERSION=10
export GCCLIB=/lib/x86_64-linux-gnu

#issues with gfortran 10 and mpich, netcdf (prior to 4.7) and delft3d
# The flag below is still needed for mpich and deltares_common
# GCC10 now checks calls to definitions and thus can find more errors and dirty
# tricks. Packages will adapt over time, but some slowly.
export flags="${flags} -fallow-argument-mismatch" 
        
#export PATH=${GCCROOT}/bin:${PATH}
#export LD_LIBRARY_PATH=${GCCROOT}/bin:${LD_LIBRARY_PATH}

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
else
   echo "Building local MPICH"
fi

#NETCDF
export NETCDF_LOCAL=T
if [ "${NETCDF_LOCAL}" == "F" ]; then
   echo "No pre-compiled NETCDF here."
   exit 1
else
   echo "Building local NetCDF"
fi

#PETSC
export PETSC_LOCAL=T
if [ "${PETSC_LOCAL}" == "F" ]; then
   echo "No pre-compiled PETSC here."
   exit 1
else
   echo "Building local PETSC"
fi

#METIS systerm
export METIS_LOCAL=T
if [ "$METIS_LOCAL}" == "F" ]; then
   echo "No pre-compiled METIS here."
   exit 1
else
   echo "Building local Metis"
fi

export SETTINGS=T
