#! /bin/bash
# startup script for partitioning the network for dflowfm

if [ $# -lt 2 ] ; then
   echo "usage: partition.sh <ndomains> <mdu-file>"
   exit 1
fi
export NDOM=$1
echo "Number of domains = ${NDOM}"

export MDUFILE="$2"
if [ ! -f "${MDUFILE}" ]; then
   echo "Can not find mdu-file ${MDUFILE}"
   exit 1
fi


export OMP_NUM_THREADS=3
export DFLOWFMROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export DFLOWFMROOT="${DFLOWFMROOT}/.."
export PATH=$DFLOWFMROOT/bin:$PATH
export LD_LIBRARY_PATH=$DFLOWFMROOT/lib:$LD_LIBRARY_PATH
ulimit -s unlimited

cp $DFLOWFMROOT/share/dflowfm/unstruc.ini .

echo $DFLOWFMROOT/bin/dflowfm --nodisplay --autostartstop --partition:ndomains=${NDOM}:icgsolver=6 ${MDUFILE}
$DFLOWFMROOT/bin/dflowfm --nodisplay --autostartstop --partition:ndomains=${NDOM}:icgsolver=6 ${MDUFILE}
