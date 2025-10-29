#!/bin/bash

echo "Print all args : $@"
echo "Print all args : $*"
echo "Script Name : $0"
echo "Current working Directory : $PWD"
echo "who is running this script : $USER"
echo "Home directory of the user : $HOME"
echo "PID of the current script : $$"
sleep &
echo "PID of the bg script : $!"