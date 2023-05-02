#!/bin/sh

INITIAL_CASE=1
FINAL_CASE=3
for i in $(seq $INITIAL_CASE $FINAL_CASE)
do
    echo "case: $i"
    sbatch valid_cfd.sh $i
done
