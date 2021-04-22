#! /bin/bash
# Local settings and preferences
# Platform dependencies are handled by settings/

export SVNUSER=verlaan
# Optimization vs debug
#export flags="-g"
export flags="-O2" 

#Revision for the dflow code. 
#Can also be empty to get the latest version on the trunk
#export DFLOW_REVISION=""
export DFLOW_REVISION="68758"

#compiler flags hopefully not needed
export fflags="" #included in FCFLAGS and FFLAGS for DFLOW
export lflags="" #included in LDFLAGS for DFLOW
export configureArgs=""
export CFLAGS=""
export FFLAGS=""
export FCFLAGS=""
export CXXFLAGS=""
export LDFLAGS=""
