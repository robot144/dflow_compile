#! /bin/bash
#
# Make some changes to the code.
# Try to keep this to a minimum.
#

echo "PWD=${PWD}"

# switch off compilation for swan
patch dflowfm-trunk/src/third_party_open/Makefile.am local_patches/tpo_Makefile.am.patch
patch dflowfm-trunk/src/engines_gpl/Makefile.am local_patches/engines_Makefile.am.patch
#
# remove include sys/sysctl.h
patch dflowfm-trunk/src/utils_lgpl/deltares_common/packages/deltares_common_c/src/meminfo.cpp local_patches/meminfo.cpp.patch
