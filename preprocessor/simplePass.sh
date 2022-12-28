#!/usr/bin/sh
if [[ $# -ne 2 ]]; then
    echo "usage: ./$0 fileIn fileOut"
else
    grep -o '^[^#]*' $1 > $2
fi
