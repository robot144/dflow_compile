#! /bin/bash

export REVISION="-r 68758"

if [ ! -d dflowfm-trunk ]; then
   #module load subversion
   svn co --username=${SVNUSER} ${REVISION} https://svn.oss.deltares.nl/repos/delft3d/trunk dflowfm-trunk
fi
