#! /bin/bash
# Add files that are needed to make the material in $DFLOWFMROOT self-contained.

echo "Copy additional files to folder: ${DFLOWFMROOT}"

#add runscripts
cp runscripts/*.* ${DFLOWFMROOT}/bin/

#mpi
echo "MPI: ${MPIROOT}"
cp ${MPIROOT}/bin/* ${DFLOWFMROOT}/bin/
cp -r ${MPIROOT}/lib/* ${DFLOWFMROOT}/lib/

#netcdf
echo "NETCDF: ${NETCDFROOT}"
cp ${NETCDFROOT}/bin/* ${DFLOWFMROOT}/bin/
cp -r ${NETCDFROOT}/lib/* ${DFLOWFMROOT}/lib/

#petsc
echo "PETSC: ${PETSCROOT}"
#cp ${PETSCROOT}/bin/* ${DFLOWFMROOT}/bin/
cp -r ${PETSCROOT}/lib/* ${DFLOWFMROOT}/lib/

#metis
echo "METIS: ${METISROOT}"
#cp ${METISROOT}/bin/* ${DFLOWFMROOT}/bin/
cp -r ${METISROOT}/lib/* ${DFLOWFMROOT}/lib/
