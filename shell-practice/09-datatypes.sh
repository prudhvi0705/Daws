#!/bin/bash

NUMBER1=100
NUMBER2=200
NAME=MODI

SUM=$((NUMBER1+NUMBER2+NAME))

echo "Total sum is $SUM"

Leaders=("NAMO" "TRUMP" "PUTIN" "TREDEAU")

echo "First Leader is : ${Leaders[0]}"
echo "All Leaders are : ${Leaders[@]}"