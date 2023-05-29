#!/bin/sh

INITIAL_CASE=215
FINAL_CASE=420
for i in $(seq $INITIAL_CASE $FINAL_CASE)
do
    echo "case: $i"
    sbatch snel_cfd.sh $i
    # . snel_cfd.sh $i
done
