#!/bin/bash

#SBATCH --job-name="RDK_NS"
#SBATCH --partition=compute
#SBATCH --time=02:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=20G
#SBATCH --account=Education-3mE-MSc-OE

source modules.sh

srun -n 1 julia --project=../ -O3 --check-bounds=no --color=yes compile.jl

