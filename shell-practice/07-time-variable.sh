#!/bin/bash

DATE=$(date +%D)

Start_date=$(date +%s)

sleep 10

End_date=$(date +%s)

Total_time=$(($Start_date-$End_date))

echo "Time required to execute script is : $Total_time"