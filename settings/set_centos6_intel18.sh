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
module load mpich2/3.3_intel_18.0.3
export MPIROOT=/opt/mpich2/3.3_intel18.0.3
export MPI_LOCAL=F
#NETCDF
module load netcdf/v4.6.2_v4.4.4_intel_18.0.3
export NETCDF_LOCAL=F
export NETCDFROOT=/opt/netcdf/v4.6.2_v4.4.4_intel_18.0.3
#PETSC
module load petsc/3.9.3_intel18.0.3_mpich_3.3
export PETSC_LOCAL=F
export PETSCROOT=/opt/petsc/with_mpich_3.3/3.9.3_intel18.0.3
#METIS
module load metis/5.1.0_intel18.0.3
export METIS_LOCAL=F
export METISROOT=/opt/metis/5.1.0_intel18.0.3
#setenv METIS_DIR        $prefix
#prepend-path --delim " "                CPPFLAGS                -I$prefix/include
#prepend-path --delim " "        LDFLAGS         -L$prefix/lib



export SETTINGS=T
