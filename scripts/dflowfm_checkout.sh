#! /bin/bash

if [ ! -d dflowfm-trunk ]; then
   module load subversion
   svn co --username=${SVNUSER} https://svn.oss.deltares.nl/repos/delft3d/trunk dflowfm-trunk
   #autogen
   pushd dflowfm-trunk/src
   ./autogen.sh 2>&1 |tee myautogen.log
   pushd third_party_open/kdtree2/ 
   ./autogen.sh 2>&1 |tee ../../myautogen_kdtree.log
   popd
   popd
fi
