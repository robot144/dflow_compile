#! /bin/bash

if [ ! -d dflowfm-trunk ]; then
   module load subversion
   svn co --username=verlaan https://svn.oss.deltares.nl/repos/delft3d/trunk dflowfm-trunk
   #autogen
   pushd dflowfm-trunk/src
   ./autogen.sh
   cd third_party_open/kdtree2/
   ./autogen.sh
   popd
fi
