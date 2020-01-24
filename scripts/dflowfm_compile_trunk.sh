#! /bin/bash
# settings for configure on h6 to compile portible binaries
# Needs one argument: gnu or ifort
#
# checkout and autogen autreconf are already done here.
# svn --username=verlaan co 'https://svn.oss.deltares.nl/repos/delft3d/trunk/' dflowfm-trunk
# run autogen.sh
# not run autoreconf --install

#
# check argument
#
if [ $# -lt 1 ]; then
        echo "This script needs an argument. Allowed values are: gnu or ifort"
	exit 1
fi
export COMPILERTYPE=$1 
echo "COMPILERTYPE $COMPILERTYPE"

export DFLOWFM_VERSION=trunk

# Compiler selection
if [ "$COMPILERTYPE" ==  "ifort" ]; then
	echo "Using ifort"
	export CC=mpicc
        export IFORTEXE=`which ifort`
        export IFORTDIR=`dirname $IFORTEXE`
elif [ "$COMPILERTYPE" == "gnu" ]; then
	echo "Using gcc"
	export CC=mpicc
	export FC=mpif90
else
	echo "Wrong argument for metis_install.sh Valid are ifort and gnu"
	exit 1
fi

#remove any existing targets
rm -rf dflowfm_linux64_ifort

export BASE=$PWD
pushd dflowfm-$DFLOWFM_VERSION/src

export DFLOWFMROOT=${BASE}/dflowfm_linux64_${COMPILERTYPE}
#export DFLOWFMROOT=/opt64/dflowfm

#expat QUESTION: Not needed anymore
#export EXPATROOT=${BASE}/expat_linux64_ifort
#export LD_LIBRARY_PATH=$EXPATROOT/lib:$LD_LIBRARY_PATH

#netcdf
export NETCDFROOT=${BASE}/netcdf_linux64_${COMPILERTYPE}
export PATH=$NETCDFROOT/bin:$PATH
export LD_LIBRARY_PATH=$NETCDFROOT/lib:$LD_LIBRARY_PATH

#mpi
export MPI_ROOT=${BASE}/mpich_linux64_${COMPILERTYPE}
export MPI_LIBS="-L${MPI_ROOT}/lib -lmpich -lpthread -lrt -i-static"
export MPI_RSH="rsh"
export PATH=$MPI_ROOT/bin:$PATH
export LD_LIBRARY_PATH=$MPI_ROOT/lib:$LD_LIBRARY_PATH
#this should not be needed, but is for now
export LDFLAGS="-L$BASE/mpich_linux64_ifort/lib"

#petsc
export PETSC_ROOT=$BASE/petsc_linux64_${COMPILERTYPE}

#metis
export METIS_ROOT=$BASE/metis_linux64_${COMPILERTYPE}
#export METIS_ROOT=/opt/metis/5.1.0_intel16.0.3

export OPTIM="-g -O2 "
#in repos?? export OPTIM="-O2"
#export OPTIM="-O3"
FFLAGS="$OPTIM -I$NETCDFROOT/include/ -I$MPI_ROOT/include/ -I$METIS_ROOT/include" \
     FCFLAGS="$OPTIM -I$NETCDFROOT/include/ -I$MPI_ROOT/include/ -I$METIS_ROOT/include" \
     CFLAGS="$OPTIM -I$EXPATROOT/include -I$NETCDFROOT/include/ -I$MPI_ROOT/include/ -I$METIS_ROOT/include "\
     CPPFLAGS="$OPTIM -I$EXPATROOT/include -I$NETCDFROOT/include/ -I$MPI_ROOT/include/ -I$METIS_ROOT/include " \
     LDFLAGS="-L$MPI_ROOT/lib -L$EXPATROOT/lib -L$METIS_ROOT/lib" \
     NETCDF_FORTRAN_CFLAGS=-I${NETCDFROOT}/include \
     NETCDF_FORTRAN_LIBS="-L${NETCDFROOT}/lib -lnetcdf -lnetcdff" \
     PKG_CONFIG_PATH=${NETCDFROOT}/lib/pkgconfig:${PETSC_ROOT}/lib/pkgconfig \
     ./configure --prefix=$DFLOWFMROOT --with-mpi --with-petsc --with-metis=${METIS_ROOT} \
      2>&1 |tee myconfig.log
#    CFLAGS='-O2' CXXFLAGS='-O2' FFLAGS='-O2' FCFLAGS='-O2' ./configure --prefix=`pwd` --with-netcdf --with-mpi --with-metis --with-petsc
#make 2>&1 |tee mymake.log

exit 1

FC=mpif90 make ds-install 2>&1 |tee mymake.log

FC=mpif90 make ds-install -C engines_gpl/dflowfm 2>&1 |tee mymake_dflowfm.log

#make ds-install
#FC=mpif90 make ds-install -C engines_gpl/dflowfm

#make install 2>&1 |tee myinstall.log

rsync -ruav $NETCDFROOT/bin/ $DFLOWFMROOT/bin
rsync -ruav $NETCDFROOT/lib/ $DFLOWFMROOT/lib
rsync -ruav $MPI_ROOT/bin/ $DFLOWFMROOT/bin
rsync -ruav $MPI_ROOT/lib/ $DFLOWFMROOT/lib
#ifort libs are now picked up automatically
#cp $IFORTLIB/libifport.so.5 $DFLOWFMROOT/lib
#cp $IFORTLIB/libifcore.so.5 $DFLOWFMROOT/lib
#cp $IFORTLIB/libimf.so $DFLOWFMROOT/lib
#cp $IFORTLIB/libsvml.so $DFLOWFMROOT/lib
#cp $IFORTLIB/libintlc.so.5 $DFLOWFMROOT/lib
#cp $IFORTLIB/libiomp5.so $DFLOWFMROOT/lib
#cp $IFORTLIB/libirc.so $DFLOWFMROOT/lib
#cp $IFORTLIB/libirng.so $DFLOWFMROOT/lib
#cp $IFORTLIB/libcilkrts.so.5 $DFLOWFMROOT/lib
#cp $IFORTLIB/../../../mkl/lib/intel64/libmkl_intel_lp64.so $DFLOWFMROOT/lib
#cp $IFORTLIB/../../../mkl/lib/intel64/libmkl_intel_thread.so $DFLOWFMROOT/lib
#cp $IFORTLIB/../../../mkl/lib/intel64/libmkl_core.so $DFLOWFMROOT/lib
#cp $IFORTLIB/../../../mkl/lib/intel64/libmkl_avx2.so $DFLOWFMROOT/lib
##cp $IFORTLIB/../../../mpi/intel64/lib/libmpi.so.12 $DFLOWFMROOT/lib
##cp $IFORTLIB/../../../mpi/intel64/lib/libmpifort.so.12 $DFLOWFMROOT/lib
#
cp $PETSC_ROOT/lib/libpetsc.so*  $DFLOWFMROOT/lib/
#cp $EXPATROOT/lib/libexpat.so.0  $DFLOWFMROOT/lib/
cp $METIS_ROOT/lib/libmetis.so  $DFLOWFMROOT/lib/


echo '#! /bin/bash' >$DFLOWFMROOT/bin/dflowfm.sh
echo '# startup script for dflowfm' >>$DFLOWFMROOT/bin/dflowfm.sh
echo '' >>$DFLOWFMROOT/bin/dflowfm.sh
echo 'if [ $# -eq 0 ] ; then' >>$DFLOWFMROOT/bin/dflowfm.sh
echo '   echo "usage: dflowfm.sh <input-file>> [options]"' >>$DFLOWFMROOT/bin/dflowfm.sh
echo 'fi' >>$DFLOWFMROOT/bin/dflowfm.sh
echo 'export OMP_NUM_THREADS=3' >>$DFLOWFMROOT/bin/dflowfm.sh
echo 'export DFLOWFMROOT=/opt64/dflowfm' >>$DFLOWFMROOT/bin/dflowfm.sh
echo 'export DFLOWFMROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"' >>$DFLOWFMROOT/bin/dflowfm.sh
echo 'export DFLOWFMROOT="${DFLOWFMROOT}/.."' >>$DFLOWFMROOT/bin/dflowfm.sh
echo '' >>$DFLOWFMROOT/bin/dflowfm.sh
echo 'export PATH=$DFLOWFMROOT/bin:$PATH' >>$DFLOWFMROOT/bin/dflowfm.sh
echo 'export LD_LIBRARY_PATH=$DFLOWFMROOT/lib:$LD_LIBRARY_PATH' >>$DFLOWFMROOT/bin/dflowfm.sh
echo 'ulimit -s unlimited' >>$DFLOWFMROOT/bin/dflowfm.sh
echo '' >>$DFLOWFMROOT/bin/dflowfm.sh
echo '$DFLOWFMROOT/bin/dflowfm $* --autostartstop' >>$DFLOWFMROOT/bin/dflowfm.sh
chmod +x $DFLOWFMROOT/bin/dflowfm.sh

echo '#! /bin/bash' >$DFLOWFMROOT/bin/dflowfm_parallel.sh
echo '# startup script for dflowfm with mpi' >>$DFLOWFMROOT/bin/dflowfm_parallel.sh
echo '' >>$DFLOWFMROOT/bin/dflowfm_parallel.sh
echo 'if [ $# -lt 2 ] ; then' >>$DFLOWFMROOT/bin/dflowfm_parallel.sh
echo '   echo "usage: dflowfm_parallel.sh <number of processes> <input-file>> "' >>$DFLOWFMROOT/bin/dflowfm_parallel.sh
echo '   exit 1 ' >>$DFLOWFMROOT/bin/dflowfm_parallel.sh
echo 'fi' >>$DFLOWFMROOT/bin/dflowfm_parallel.sh
echo 'export OMP_NUM_THREADS=1' >>$DFLOWFMROOT/bin/dflowfm_parallel.sh
echo 'export DFLOWFMROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"' >>$DFLOWFMROOT/bin/dflowfm_parallel.sh
echo 'export DFLOWFMROOT="${DFLOWFMROOT}/.."' >>$DFLOWFMROOT/bin/dflowfm_parallel.sh
echo '' >>$DFLOWFMROOT/bin/dflowfm_parallel.sh
echo 'export PATH=$DFLOWFMROOT/bin:$PATH' >>$DFLOWFMROOT/bin/dflowfm_parallel.sh
echo 'export LD_LIBRARY_PATH=$DFLOWFMROOT/lib:$LD_LIBRARY_PATH' >>$DFLOWFMROOT/bin/dflowfm_parallel.sh
echo 'ulimit -s unlimited' >>$DFLOWFMROOT/bin/dflowfm_parallel.sh
echo 'cp $DFLOWFMROOT/share/dflowfm/unstruc.ini .' >>$DFLOWFMROOT/bin/dflowfm_parallel.sh
echo '' >>$DFLOWFMROOT/bin/dflowfm_parallel.sh
echo 'export workingdir=`dirname $1` ' >>$DFLOWFMROOT/bin/dflowfm_parallel.sh
echo 'export hostfile="${workingdir}/hostfile" ' >>$DFLOWFMROOT/bin/dflowfm_parallel.sh
echo 'export "hostfile=${hostfile}" ' >>$DFLOWFMROOT/bin/dflowfm_parallel.sh
echo 'export HOSTOPTION="" ' >>$DFLOWFMROOT/bin/dflowfm_parallel.sh
echo 'if [ -f "$hostfile" ];then ' >>$DFLOWFMROOT/bin/dflowfm_parallel.sh
echo '   export HOSTOPTION=" -f $hostfile " ' >>$DFLOWFMROOT/bin/dflowfm_parallel.sh
echo 'fi ' >>$DFLOWFMROOT/bin/dflowfm_parallel.sh
echo 'echo $DFLOWFMROOT/bin/mpirun ${HOSTOPTION} -n $1 $DFLOWFMROOT/bin/dflowfm -autostartstop $2' >>$DFLOWFMROOT/bin/dflowfm_parallel.sh
echo '$DFLOWFMROOT/bin/mpirun ${HOSTOPTION} -n $1 $DFLOWFMROOT/bin/dflowfm -autostartstop $2' >>$DFLOWFMROOT/bin/dflowfm_parallel.sh
chmod +x $DFLOWFMROOT/bin/dflowfm_parallel.sh


echo '#! /bin/bash' >>$DFLOWFMROOT/bin/partition.sh
echo '# startup script for partitioning the network for dflowfm' >>$DFLOWFMROOT/bin/partition.sh
echo '' >>$DFLOWFMROOT/bin/partition.sh
echo 'if [ $# -lt 2 ] ; then' >>$DFLOWFMROOT/bin/partition.sh
echo '   echo "usage: partition.sh <ndomains> <mdu-file>"' >>$DFLOWFMROOT/bin/partition.sh
echo '   exit 1' >>$DFLOWFMROOT/bin/partition.sh
echo 'fi' >>$DFLOWFMROOT/bin/partition.sh
echo 'export NDOM=$1' >>$DFLOWFMROOT/bin/partition.sh
echo 'echo "Number of domains = ${NDOM}"' >>$DFLOWFMROOT/bin/partition.sh
echo '' >>$DFLOWFMROOT/bin/partition.sh
echo 'export MDUFILE="$2"' >>$DFLOWFMROOT/bin/partition.sh
echo 'if [ ! -f "${MDUFILE}" ]; then' >>$DFLOWFMROOT/bin/partition.sh
echo '   echo "Can not find mdu-file ${MDUFILE}"' >>$DFLOWFMROOT/bin/partition.sh
echo '   exit 1' >>$DFLOWFMROOT/bin/partition.sh
echo 'fi' >>$DFLOWFMROOT/bin/partition.sh
echo '' >>$DFLOWFMROOT/bin/partition.sh
echo '' >>$DFLOWFMROOT/bin/partition.sh
echo 'export OMP_NUM_THREADS=3' >>$DFLOWFMROOT/bin/partition.sh
echo 'export DFLOWFMROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"' >>$DFLOWFMROOT/bin/partition.sh
echo 'export DFLOWFMROOT="${DFLOWFMROOT}/.."' >>$DFLOWFMROOT/bin/partition.sh
echo 'export PATH=$DFLOWFMROOT/bin:$PATH' >>$DFLOWFMROOT/bin/partition.sh
echo 'export LD_LIBRARY_PATH=$DFLOWFMROOT/lib:$LD_LIBRARY_PATH' >>$DFLOWFMROOT/bin/partition.sh
echo 'ulimit -s unlimited' >>$DFLOWFMROOT/bin/partition.sh
echo '' >>$DFLOWFMROOT/bin/partition.sh
echo '' >>$DFLOWFMROOT/bin/partition.sh
echo 'echo $DFLOWFMROOT/bin/dflowfm --nodisplay --autostartstop --partition:ndomains=${NDOM}:icgsolver=6 ${MDUFILE}' >>$DFLOWFMROOT/bin/partition.sh
echo '$DFLOWFMROOT/bin/dflowfm --nodisplay --autostartstop --partition:ndomains=${NDOM}:icgsolver=6 ${MDUFILE}' >>$DFLOWFMROOT/bin/partition.sh
chmod +x $DFLOWFMROOT/bin/partition.sh

popd
