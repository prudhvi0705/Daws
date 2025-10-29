#!/bin/bash

NUMBER=$1

if [ $((NUMBER%2)) -eq 0 ]; then
    echo "Given number $NUMBER is even"
else
    echo "Given number $NUMBER is odd"
fi