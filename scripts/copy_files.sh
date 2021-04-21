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
if [ ! -z "${MPIROOT}" ];then
   if [ -d ${MPIROOT}/bin ];then
     cp ${MPIROOT}/bin/* ${DFLOWFMROOT}/bin/
   fi
   if [ -d ${MPIROOT}/lib ];then
     cp ${MPIROOT}/lib/* ${DFLOWFMROOT}/lib/
   fi
fi 

#netcdf
echo "NETCDF: ${NETCDFROOT}"
if [ ! -z "${NETCDFROOT}" ];then
   if [ -d ${NETCDFROOT}/bin ];then
      cp ${NETCDFROOT}/bin/* ${DFLOWFMROOT}/bin/
   fi
   if [ -d ${NETCDFROOT}/lib ];then
      cp ${NETCDFROOT}/lib/*.* ${DFLOWFMROOT}/lib/
   fi
fi

#petsc
echo "PETSC: ${PETSCROOT}"
#cp ${PETSCROOT}/bin/* ${DFLOWFMROOT}/bin/
if [ ! -z "${PETSCROOT}" ];then
   if [ -d ${PETSCROOT}/lib ];then
      cp ${PETSCROOT}/lib/*.* ${DFLOWFMROOT}/lib/
   fi
fi

#metis
echo "METIS: ${METISROOT}"
#cp ${METISROOT}/bin/* ${DFLOWFMROOT}/bin/
if [ ! -z "${METISROOT}" ];then
   if [ -d ${METISROOT}/lib ];then
      cp ${METISROOT}/lib/*.* ${DFLOWFMROOT}/lib/
   fi
fi


