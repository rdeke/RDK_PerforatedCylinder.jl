module load 2022r2 openmpi intel-mkl
export LD_LIBRARY_PATH=$HOME/progs/install/petsc/3.15.4/lib:$LD_LIBRARY_PATH
export JULIA_MPI_BINARY=system
export JULIA_MPI_PATH=/apps/arch/2022r2/software/linux-rhel8-skylake_avx512/gcc-8.5.0/openmpi-4.1.1-fezcq73heq4rzzsbcumuq5xx4v5asv45
export JULIA_MPIEXEC=srun
export JULIA_PETSC_LIBRARY=$HOME/progs/install/petsc/3.15.4/lib/libpetsc.so
export PerforatedCylinder_DATA=/scratch/rdekeyser/RDK_PerforatedCylinder.jl/data/
export PerforatedCylinder_MESHES=/scratch/rdekeyser/RDK_PerforatedCylinder.jl/data/meshes
export PerforatedCylinder_LOGS=/scratch/rdekeyser/RDK_PerforatedCylinder.jl/data/logs
export PerforatedCylinder_FORCES=/scratch/rdekeyser/RDK_PerforatedCylinder.jl/data/forces
export PerforatedCylinder_VTKS=/scratch/rdekeyser/RDK_PerforatedCylinder.jl/data/vtk
