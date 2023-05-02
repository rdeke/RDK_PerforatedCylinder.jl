#!/bin/sh
#
#SBATCH --job-name="RDK_NS"
#SBATCH --partition=compute
#SBATCH --time=01:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=20G
#SBATCH --account=Education-3mE-MSc-OE
#SBATCH --output=slurm-%j-%4t.out

source ../../compile/modules.sh

## srun -n 1 julia --project=../../ -J ../../PerforatedCylinder_parallel.so -O3 --check-bounds=no -e 'include("conv_msh.jl")'
srun -n 1 julia --project=../../ -O3 --check-bounds=no -e 'include("conv_msh.jl")'