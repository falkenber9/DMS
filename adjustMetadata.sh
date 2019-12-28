#!/bin/bash

workdir=$1

for sourcefile in $workdir/*.[Pp][Dd][Ff]; do
    echo "Verarbeite: $sourcefile"
    filename=`basename "$sourcefile"`
    title="${filename%.[pP][dD][fF]}"
    ./add-metadata.sh "$sourcefile" "$sourcefile-2" "$title"
    rm "$sourcefile"
    mv "$sourcefile-2" "$sourcefile"
done
