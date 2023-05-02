#!/bin/sh
#
#SBATCH --job-name="RDK_NS"
#SBATCH --partition=compute
#SBATCH --time=23:59:59
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=32G
#SBATCH --account=Education-3mE-MSc-OE
#SBATCH --output=slurm-%j-%4t.out

source ../../compile/modules.sh

export CASE_ID=2
echo "Starting case: $CASE_ID"

srun -n 1 julia --project=../../ -J ../../PerforatedCylinder_parallel.so -O3 --check-bounds=no -e 'include("valid_cfd.jl")'
