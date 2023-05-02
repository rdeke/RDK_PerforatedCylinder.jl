#!/bin/sh

INITIAL_CASE=1
FINAL_CASE=4
for i in $(seq $INITIAL_CASE $FINAL_CASE)
do
    echo "case: $i"
    sbatch test_cfd_original.sh $i
done
