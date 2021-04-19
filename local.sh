#! /bin/bash
# Local settings and preferences
# Platform dependencies are handled by settings/

export SVNUSER=verlaan
# Optimization vs debug
#export flags="-g"
#export flags="-O2 -fallow-argument-mismatch" #issues with gfortran 10
export flags="-O2" 

#compiler flags hopefully not needed
export fflags="" #included in FCFLAGS and FFLAGS for DFLOW
export lflags="" #included in LDFLAGS for DFLOW
export configureArgs=""
export CFLAGS=""
export FFLAGS=""
export FCFLAGS=""
export CXXFLAGS=""
export LDFLAGS=""
