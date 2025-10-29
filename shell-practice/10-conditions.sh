#!/bin/bash

NUMBER=$1

if [ $NUMBER -eq 10]; then
    echo "Given number $NUMBER is equal to 10"
elif [ $NUMBER -gt 10 ]; then
    echo "Given number $NUMBER is greater than 10"
else [ $NUMBER -lt 10]
    echo "Given number $NUMBER is less than 10"
fi