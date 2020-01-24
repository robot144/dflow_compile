#! /bin/bash
# startup script for dflowfm with mpi

if [ $# -lt 2 ] ; then
   echo "usage: dflowfm_parallel.sh <number of processes> <input-file>> "
   exit 1 
fi
export OMP_NUM_THREADS=1
export DFLOWFMROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export DFLOWFMROOT="${DFLOWFMROOT}/.."

export PATH=$DFLOWFMROOT/bin:$PATH
export LD_LIBRARY_PATH=$DFLOWFMROOT/lib:$LD_LIBRARY_PATH
ulimit -s unlimited
cp $DFLOWFMROOT/share/dflowfm/unstruc.ini .

export workingdir=`dirname $1` 
export hostfile="${workingdir}/hostfile" 
export "hostfile=${hostfile}" 
export HOSTOPTION="" 
if [ -f "$hostfile" ];then 
   export HOSTOPTION=" -f $hostfile " 
fi 
echo $DFLOWFMROOT/bin/mpirun ${HOSTOPTION} -n $1 $DFLOWFMROOT/bin/dflowfm -autostartstop $2
$DFLOWFMROOT/bin/mpirun ${HOSTOPTION} -n $1 $DFLOWFMROOT/bin/dflowfm -autostartstop $2
