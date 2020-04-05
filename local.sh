#! /bin/bash
# Local settings and preferences
# Platform dependencies are handled by settings/

export SVNUSER=verlaan
# Optimization vs debug
# flags included for included in CFLAGS, CXXFLAGS, FCFLAGS and FFLAGS for DFLOW
export flags="-g -static-intel"
#export flags="-O2"

#compiler flags hopefully not needed
export fflags="" #included in FCFLAGS and FFLAGS for DFLOW
export lflags="" #included in LDFLAGS for DFLOW
export configureArgs=""
export CFLAGS=""
export FFLAGS=""
export FCFLAGS=""
export CXXFLAGS=""
export LDFLAGS=""
