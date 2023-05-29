#!/bin/sh
#
#SBATCH --job-name="perf_cylinder"
#SBATCH --partition=thin
#SBATCH --time=1-23:59:59
#SBATCH -n 12
#SBATCH -o stdout/slurm-%j-%4t.out
#SBATCH -e stdout/slurm-%j-%4t.err

source ../../compile_snellius/modules_snellius.sh

# for i in `seq 1 8`; do
# export CASE_ID=$(( ($1-1) * 8 + $i ))
export CASE_ID=$1
echo "Launching case: $CASE_ID"
srun -n 12 julia --project=../../ -J ../../PerforatedCylinder_parallel.so -O3 --check-bounds=no -e 'include("snel_cfd.jl"); SNEL_CFD.main( parse(Int,ENV["CASE_ID"]) )'   
#done
#wait