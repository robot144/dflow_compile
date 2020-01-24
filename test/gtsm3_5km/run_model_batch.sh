#! /bin/bash
# run mode with dflowfm

export model="gtsm_fine.mdu"
export ndom=4

export PATH=$PWD/../dflowfm_linux64_binaries/bin:$PATH

#partition grid and mdu files
partition_portable.sh ${ndom} ${model}

#make run
dflowfm_parallel_portable.sh ${ndom} ${model} 
