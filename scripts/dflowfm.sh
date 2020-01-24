#! /bin/bash
# startup script for dflowfm

if [ $# -eq 0 ] ; then
   echo "usage: dflowfm.sh <input-file>> [options]"
fi
export OMP_NUM_THREADS=3
export DFLOWFMROOT=/opt64/dflowfm
export DFLOWFMROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export DFLOWFMROOT="${DFLOWFMROOT}/.."

export PATH=$DFLOWFMROOT/bin:$PATH
export LD_LIBRARY_PATH=$DFLOWFMROOT/lib:$LD_LIBRARY_PATH
ulimit -s unlimited
cp $DFLOWFMROOT/share/dflowfm/unstruc.ini .

$DFLOWFMROOT/bin/dflowfm $* --autostartstop
