#! /bin/bash
# Add files that are needed to make the material in $DFLOWFMROOT self-contained.

echo "Copy additional files to folder: ${DFLOWFMROOT}"

if [ -z "${DFLOWFMROOT}" ]; then
   echo "Variable DFLOWFMROOT was empty. This script relies on several env vars."
   echo "It is normally called from runall.sh, not directly."
   exit 1
fi

#add runscripts
cp runscripts/*.* ${DFLOWFMROOT}/bin/

#mpi
echo "MPI: ${MPIROOT}"
cp ${MPIROOT}/bin/* ${DFLOWFMROOT}/bin/
cp ${MPIROOT}/lib/* ${DFLOWFMROOT}/lib/

#netcdf
echo "NETCDF: ${NETCDFROOT}"
cp ${NETCDFROOT}/bin/* ${DFLOWFMROOT}/bin/
cp ${NETCDFROOT}/lib/*.* ${DFLOWFMROOT}/lib/

#petsc
echo "PETSC: ${PETSCROOT}"
#cp ${PETSCROOT}/bin/* ${DFLOWFMROOT}/bin/
cp ${PETSCROOT}/lib/*.* ${DFLOWFMROOT}/lib/

#metis
echo "METIS: ${METISROOT}"
#cp ${METISROOT}/bin/* ${DFLOWFMROOT}/bin/
cp ${METISROOT}/lib/*.* ${DFLOWFMROOT}/lib/
