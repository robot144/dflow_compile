#! /bin/bash

. ./set_devux_intel18.sh

./dflowfm_checkout.sh

./mpi_install.sh ifort 64 noshared

./netcdf_install.sh ifort 64 netcdf4

./petsc_install.sh

./metis_install.sh

./dflowfm_compile_trunk_intel18.sh
