# dflow_compile
This repository contains some scripts to compile dflow (Delft3D Flexible Mesh) on linux systems.
Currently the scripts support:
os       | compiler    | status
-----
centos-6 | intel18.0.3 | working
centos-6 | gcc-4.9.2   | not working
centos-7 | intel 18    | not working
centos-7 | gcc-4.9.2   | not working 

## Compilation
- Change the username in local.sh to your id as used in the Delft3D repository (contact oss.deltares.nl if you do not have one).
- run `./runall.sh` which will list allowed combinations. Select the correct option for your system 
- run `./runall.sh <your-system>` 
  This will checkout the source compile the required mpich, hdf, netcdf, metis and petsc and finally delft3d and delft3d-fm. This will take a while.
  
## Other tasks
- `./clean.sh` to remove all build material for mpich, hdf, netcdf, metis, petsc, and delf3d. The source is not deleted. This script is intended to build from scratch.
- If you delete dflowfm_linux_gnu or dflowfm_linux_ifort before using runall.sh again will just compile detft3d-dflow again.
- In several configurations there is a choice between system installed and locally compiled libraries in the corresponding settings file.
- Subversion actions are still to be made manually.

## Tests
There are two test-cases available: a very simple model and a global tide-model. For the global tide model you will need to unzip one file (was too large for github)
For example:
`cd test/estuary_model`
`../../dflowfm_linux_ifort/bin/dflow.sh estuary.mdu` For a scalar run with intel compiled binaries
`../../dflowfm_linux_ifort/bin/partition.sh 2 estuary.mdu` Partition into two domains to prepare for parallel run
`../../dflowfm_linux_ifort/bin/dflow_parallel.sh 2 estuary.mdu` Execute parallel run


