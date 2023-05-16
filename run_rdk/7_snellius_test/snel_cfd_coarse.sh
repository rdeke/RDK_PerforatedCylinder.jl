#!/bin/sh
#
#SBATCH --job-name="perf_cylinder"
#SBATCH --partition=thin
#SBATCH --time=0-03:00:00
#SBATCH -n 2
#SBATCH -o stdout/slurm-%j-%4t.out
#SBATCH -e stdout/slurm-%j-%4t.err

source ../../compile_snellius/modules_snellius.sh
mpiexecjl --project=../../ -n 2 julia -J ../../PerforatedCylinder_parallel.so -O3 --check-bounds=no -e 'include("snel_cfd_coarse.jl")'