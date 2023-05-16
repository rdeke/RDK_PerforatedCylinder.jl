#!/bin/sh
#
#SBATCH --job-name="perf_cylinder"
#SBATCH --partition=thin
#SBATCH --time=0-03:00:00
#SBATCH -n 24
#SBATCH -o stdout/slurm-%j-%4t.out
#SBATCH -e stdout/slurm-%j-%4t.err

source ../../compile_snellius/modules_snellius.sh
export CASE_ID=$1
echo "Starting case: $CASE_ID"
mpiexecjl --project=../../ -n 24 julia -J ../../PerforatedCylinder_parallel.so -O0 --check-bounds=no -e 'include("snel_cfd.jl")'