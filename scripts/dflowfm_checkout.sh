#! /bin/bash

#makes use of DFLOW_REVISION from the environmen 
# can also be empty to get the latest version on the trunk.

if [ -z "${DFLOW_REVISION}" ];then
   echo "Checking out head of trunk for delft3d/dflow."
else
   echo "Checking out revision ${DFLOW_REVISION} for delft3d/dflow."
fi
export SVN_OPTION=""
if [ ! -z "${DFLOW_REVISION}" ];then
   export SVN_OPTION="-r${DFLOW_REVISION}"
fi


export D3DURL="https://svn.oss.deltares.nl/repos/delft3d/trunk"
if [ ! -d dflowfm-trunk ]; then
   #module load subversion
   svn co --username=${SVNUSER} ${SVN_OPTION} ${D3DURL} dflowfm-trunk
   if [ $? -ne 0 ]; then
      echo "Problems during checkout of ${D3DURL}"
      exit 1
   fi
fi
