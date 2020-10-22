#! /bin/bash
# Copy fortran libraries to lib folder, so the program can work on another computer.

if [ -z "$DFLOWFMROOT" ] ;then
   echo "DFLOWFMROOT is not set. Wil copy files to DFLOWFMROOT/lib"
else
   echo "DFLOWFMROOT=$DFLOWFMROOT"
fi

if [ ! -d "$IFORTLIB" ] ;then
   echo "IFORTLIB is not pointing to a folder. IFORTLIB=$IFORTLIB"
   exit 1
else
   # copy compiler libraries that are needed at runtime
   cp $IFORTLIB/libifport.so.5 $DFLOWFMROOT/lib
   cp $IFORTLIB/libifcore.so.5 $DFLOWFMROOT/lib
   cp $IFORTLIB/libifcoremt.so.5 $DFLOWFMROOT/lib
   cp $IFORTLIB/libimf.so $DFLOWFMROOT/lib
   cp $IFORTLIB/libsvml.so $DFLOWFMROOT/lib
   cp $IFORTLIB/libintlc.so.5 $DFLOWFMROOT/lib
   cp $IFORTLIB/libiomp5.so $DFLOWFMROOT/lib
   cp $IFORTLIB/libirc.so $DFLOWFMROOT/lib
   cp $IFORTLIB/libirng.so $DFLOWFMROOT/lib
   cp $IFORTLIB/libcilkrts.so.5 $DFLOWFMROOT/lib
   #cp $IFORTLIB/../../../mkl/lib/intel64/libmkl_intel_lp64.so $DFLOWFMROOT/lib
   #cp $IFORTLIB/../../../mkl/lib/intel64/libmkl_intel_thread.so $DFLOWFMROOT/lib
   #cp $IFORTLIB/../../../mkl/lib/intel64/libmkl_core.so $DFLOWFMROOT/lib
   #cp $IFORTLIB/../../../mkl/lib/intel64/libmkl_avx2.so $DFLOWFMROOT/lib
   #cp $IFORTLIB/../../../mpi/intel64/lib/libmpi.so.12 $DFLOWFMROOT/lib
   #cp $IFORTLIB/../../../mpi/intel64/lib/libmpifort.so.12 $DFLOWFMROOT/lib
   rm -f $DFLOWFMROOT/lib/dflowfm_linux64_ub19ifort20_o3/lib/libc.so.6
   rm -f $DFLOWFMROOT/lib/dflowfm_linux64_ub19ifort20_o3/lib/libdl.so.2
   rm -f $DFLOWFMROOT/lib/dflowfm_linux64_ub19ifort20_o3/lib/libexpat.so.1
   rm -f $DFLOWFMROOT/lib/dflowfm_linux64_ub19ifort20_o3/lib/libgcc_s.so.1
   rm -f $DFLOWFMROOT/lib/dflowfm_linux64_ub19ifort20_o3/lib/libm.so.6
   rm -f $DFLOWFMROOT/lib/dflowfm_linux64_ub19ifort20_o3/lib/libopa.so
   rm -f $DFLOWFMROOT/lib/dflowfm_linux64_ub19ifort20_o3/lib/libpthread.so.0
   rm -f $DFLOWFMROOT/lib/dflowfm_linux64_ub19ifort20_o3/lib/libstdc++.so.6
fi
