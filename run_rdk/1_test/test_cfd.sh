#!/bin/sh
#
#SBATCH --job-name="RDK_NS"
#SBATCH --partition=compute
#SBATCH --time=02:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=12
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=10G
#SBATCH --account=Education-3mE-MSc-OE
#SBATCH --output=slurm-%j-%4t.out

source ../../compile/modules.sh

export CASE_ID=$1
echo "Starting case: $CASE_ID"

srun -n 12 julia --project=../../ -J ../../PerforatedCylinder_parallel.so -O3 --check-bounds=no -e 'include("test_cfd.jl")'
