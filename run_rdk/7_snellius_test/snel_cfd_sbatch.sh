#!/bin/sh

INITIAL_CASE=1
FINAL_CASE=1
for i in $(seq $INITIAL_CASE $FINAL_CASE)
do
    echo "case: $i"
    sbatch snel_cfd_6.sh $i
    sbatch snel_cfd_12.sh $i
    sbatch snel_cfd_24.sh $i
    sbatch snel_cfd_32.sh $i
    sbatch snel_cfd_64.sh $i
done


