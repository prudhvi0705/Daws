#!/bin/bash

set -euo pipefail

error(){
    echo "There is error in script"
}

trap error ERR

echo "Hello"
echo "This is before error"
ccdfghsij
echo "This is after error"