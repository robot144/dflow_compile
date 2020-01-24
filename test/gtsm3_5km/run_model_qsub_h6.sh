#! /bin/bash
# ===========================================================================
# Name    : run_model_qsub_lisa.sh
# Purpose : startup script for dflowfm through scheduler with qsub
# Args    : none
# Comments: this script must be started in the same direcory as the input files.
# Date    : APR 2014
# Author  : MVL
# ===========================================================================
# model to run:
export ndom=4
export nnode=1
export mdufile=gtsm_fine.mdu
# name used for qsub:
export name="gtsm3_5km"
export maxwalltime="00:30:00"
# purpose of run
export purpose="Small test"
echo "========================================================================="
echo "Submitting Dflow-FM run $name in  $PWD"
echo "Purpose: $purpose"
echo "Starting on $ndom domains, $nnode nodes"
echo "Lisa wall-clock-limit set to $maxwalltime"

# find out where this script is
#basedir=`(cd \`dirname $0\`; pwd)`
basedir=$PWD

#create this empty file when run is done
export donefile="$basedir/$name.done"

#Delete existing output and error files
rm -f $basedir/$name.out
rm -f $basedir/$name.err
rm -f $donefile

#Partition mdu file
$PWD/../dflowfm_linux64_binaries/bin/partition_portable.sh $ndom $mdufile 
#Start qsub 


echo "#! /bin/sh" >qsub_$name.sh
echo "#$ -q normal-e3" >>qsub_$name.sh
echo "#$ -pe distrib ${nnode}" >>qsub_$name.sh
echo "#$ -cwd " >>qsub_$name.sh
echo "# usage: qsub ./$qsub_$name.sh -pe distrib ${nnode} -q normal-e3" >>qsub_$name.sh
echo "#PBS -N $name" >>qsub_$name.sh
echo "cd $basedir" >>qsub_$name.sh
echo "env >env.txt" >>qsub_$name.sh
echo "if [ ! -z \"\$PE_HOSTFILE\" ];then" >>qsub_$name.sh
echo "    awk '{print \$1}' \$PE_HOSTFILE >hostfile" >>qsub_$name.sh
echo "fi" >>qsub_$name.sh
echo "$PWD/../dflowfm_linux64_binaries/bin/dflowfm_parallel_portable.sh $ndom $mdufile " >>qsub_$name.sh
echo "touch $donefile" >>qsub_$name.sh
chmod +x qsub_$name.sh
export result=`qsub -pe distrib $nnode -q normal-e3 -N $name ./qsub_$name.sh`
echo "qsub --> $result"
echo $?
qstat -u $USER

echo "Submitting done."
echo "========================================================================="
