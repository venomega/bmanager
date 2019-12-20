#!/usr/bin/bash

LEFT="${1}"
RIGHT="${3}"
FILE="${2}"
LINES=$(wc -l "${2}" | cut -d " " -f 1)


for i in $(seq 1 $LINES);
do
    token=$(cat "${2}" | sed -n ${i}p)
    echo "${1} ${token} ${3}"
done

