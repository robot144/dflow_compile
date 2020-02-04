#! /bin/sh
# Settings for H6 compilation of dflow

echo "Settings for Cenots6 intel 18.0.3"

# development tools - existing on machine
module load subversion
module load intel/18.0.3
export IFORTLIB=/opt/intel/18.0.3/compilers_and_libraries_2018.3.222/linux/compiler/lib/intel64_lin
module load automake/1.14.1
module load autoconf/2.69
module load libtool/2.4.3

#MPICH
export MPI_LOCAL=T
if [ "${MPI_LOCAL}" == "F" ]; then
   module load mpich2/3.3_intel_18.0.3
   export MPIROOT=/opt/mpich2/3.3_intel18.0.3
   echo "MPIROOT = ${MPIROOT}"
else
   echo "Building local MPICH"
fi

#NETCDF
export NETCDF_LOCAL=T
if [ "${NETCDF_LOCAL}" == "F" ]; then
   module load netcdf/v4.6.2_v4.4.4_intel_18.0.3
   export NETCDFROOT=/opt/netcdf/v4.6.2_v4.4.4_intel_18.0.3
   echo "NETCDFROOT = ${NETCDFROOT}"
else
   echo "Building local NetCDF"
fi

#PETSC
export PETSC_LOCAL=T
if [ "${PETSC_LOCAL}" == "F" ]; then
   module load petsc/3.9.3_intel18.0.3_mpich_3.3
   export PETSCROOT=/opt/petsc/with_mpich_3.3/3.9.3_intel18.0.3
   echo "PETSCROOT = ${PETSCROOT}"
else
   echo "Building local PETSC"
fi

#METIS systerm
export METIS_LOCAL=T
if [ "$METIS_LOCAL}" == "F" ]; then
   module load metis/5.1.0_intel18.0.3
   export METISROOT=/opt/metis/5.1.0_intel18.0.3
   echo "METISROOT = ${METISROOT}"
else
   echo "Building local Metis"
fi

export SETTINGS=T
