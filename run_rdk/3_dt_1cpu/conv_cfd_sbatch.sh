#!/bin/sh

INITIAL_CASE=1
FINAL_CASE=8
for i in $(seq $INITIAL_CASE $FINAL_CASE)
do
    echo "case: $i"
    sbatch conv_cfd.sh $i
done
