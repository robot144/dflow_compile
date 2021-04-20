# dflow_compile

This repository contains some scripts to compile dflow (Delft3D Flexible Mesh) on linux systems.
Currently the scripts support:

*Generic versions*

|os       | compiler    | status      | comment                       |
|---------|-------------|-------------|-------------------------------|
|centos-7 | intel 18    | working     | simple tests are working      |
|centos-7 | gcc-        | unknown     |                               |
|ubuntu19 | gcc 9       | unknown     | manually change oc.c:1296     | 
|ubuntu19 | gcc-4.9.4   | unknown     | uses docker gcc4              | 
|ubuntu20 | gcc-10.2.0  | working     | workrounds for gcc10          | 

*System specific versions*

|os       | compiler    | status      | comment                       |
|---------|-------------|-------------|-------------------------------|
|cartesius| intel18     | working     | Cartesius at surfsara.nl      | 

## Compilation
- Change the username in local.sh to your id as used in the Delft3D repository (contact oss.deltares.nl if you do not have one).
- run `./runall.sh` which will list allowed combinations. Select the correct option for your system 
- run `./runall.sh <your-system>` 
  This will checkout the source compile the required mpich, hdf, netcdf, metis and petsc and finally delft3d and delft3d-fm. This will take a while.

## External libraries versus local libraries
  
On some systems aprt or all of the necessary libraries are already installed. In the settings scripts, you can select which option you want to use. The option with local libraries will compile the necessary libraries from source. This creates fewer issues with versions and location of the libraries, but some computers have optimized versions of libraries.

## Other tasks
- `./clean.sh` to remove all build material for mpich, hdf, netcdf, metis, petsc, and delf3d. The source is not deleted. This script is intended to build from scratch.
- If you delete dflowfm_linux_gnu or dflowfm_linux_ifort before using runall.sh again will just compile detft3d-dflow again.
- In several configurations there is a choice between system installed and locally compiled libraries in the corresponding settings file.
- Subversion actions are still to be made manually.

## Tests
There are two test-cases available: a very simple model and a global tide-model. For the global tide model you will need to unzip one file (was too large for github)
For example:
- `cd test/estuary_model`
- `../../dflowfm_linux_ifort/bin/dflow.sh estuary.mdu` For a scalar run with intel compiled binaries
- `../../dflowfm_linux_ifort/bin/partition.sh 2 estuary.mdu` Partition into two domains to prepare for parallel run
- `../../dflowfm_linux_ifort/bin/dflow_parallel.sh 2 estuary.mdu` Execute parallel run

## Issues

Somtimes there are issues with the source or build system. Patches are
included from local_patches folder. Current status:

|Date     | Status   | Issue                                                     |
|---------|----------|-----------------------------------------------------------|
|20apr2021| ongoing  | Swan requires copies of source (not included in make)     |
|20apr2021| ongoing  | sys/sysctl.h moved to linux in ubuntu20. Works without.   |


Older issues:

- Ruby is used to copy dependent libraries into the target lib folder, but it copies too many underlying libs that will proably break things, when one copies the binaries somewhere else. In scripts/copylibs_intel.sh they are deleted again. Without ruby installed this doesn't happen, but then a few compiler specific libs are not copied along.
- On ubuntu with a modern gcc the file oc.c has 2 arguments on line 1296. With optimization, this fails for reasons unclear to me. Add a third arguments as a few lines above as a workaround.
- Before Oct 2020 there were issues with recent operating systems and compilers. Some were related to iso-c binding of strings in Fortran.

