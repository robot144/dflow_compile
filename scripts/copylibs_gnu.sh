#! /bin/bash
# Copy fortran libraries to lib folder, so the program can work on another computer.

if [ -z "$DFLOWFMROOT" ] ;then
   echo "DFLOWFMROOT is not set. Wil copy files to DFLOWFMROOT/lib"
else
   echo "DFLOWFMROOT=$DFLOWFMROOT"
fi

if [ ! -d "$GCCLIB" ] ;then
   echo "GCC pointing to a folder. GCCLIB=$GCCLIB"
   exit 1
else
   # copy compiler libraries that are needed at runtime
   cp $GCCLIB/libquadmath.so.0 $DFLOWFMROOT/lib
   cp $GCCLIB/libgfortran.so.5 $DFLOWFMROOT/lib
fi
