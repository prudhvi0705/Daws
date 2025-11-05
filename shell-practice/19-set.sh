#!/bin/bash

set -euo pipefail

error(){
    echo "There is error in script $LINENO, Command is: $BASH_COMMAND"
}

trap error ERR

echo "Hello"
echo "This is before error"
ccdfghsij
echo "This is after error"