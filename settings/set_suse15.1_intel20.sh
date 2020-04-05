#! /bin/sh
# Settings for devux7 Centos7-GCC compilation of dflow

echo "Settings for suse15.1 with gcc 7 compiler"

## no modules on devux
#module load autoconf
#module load automake
#module load libtool

#module load subversion

. /opt64/intel/intel19/bin/compilervars.sh -arch intel64 -platform linux 
export IFORTLIB=/opt64/intel/intel19/compilers_and_libraries/linux/lib/intel64_lin/

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
