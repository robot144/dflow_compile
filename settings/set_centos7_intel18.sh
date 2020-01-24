#! /bin/sh

#module load intel/18.0.3
. /opt/intel/18.0.3/bin/compilervars.sh -arch intel64 -platform linux 
export LIBIFPORT=/opt/intel/18.0.3/compilers_and_libraries_2018.3.222/linux/compiler/lib/intel64_lin
#module load autoconf
#module load automake
#module load libtool

#module load subversion
export PATH=$PATH:/opt/rh/sclo-subversion19/root/bin/svn
