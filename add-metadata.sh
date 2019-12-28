#!/bin/bash

source=$1
destination=$2
title=$3
author=$4
subject=$5

# Standardwerte
if [ -z "$title" ]; then
    filename=`basename "$source"`
    title="${filename%.[pP][dD][fF]}"
    # Dateiname ohne Dateiendung
fi

if [ -z "$author" ]; then
    author="Falkenberg"
fi

if [ -z "$subject" ]; then
    subject="Digitale Version aus dem Dokumentenverwaltungssystem"
fi

metafile="/tmp/pdf-metadata.txt"
tmpA="/tmp/pdf-stepA.pdf"
tmpB="/tmp/pdf-stepB.pdf"
echo -e "InfoKey: Title\nInfoValue: $title" > "$metafile"
pdftk "$source" update_info_utf8 "$metafile" output "$tmpA"

echo -e "InfoKey: Author\nInfoValue: $author" > "$metafile"
pdftk "$tmpA" update_info_utf8 "$metafile" output "$tmpB"
rm "$tmpA"

echo -e "InfoKey: Subject\nInfoValue: $subject" > "$metafile"
pdftk "$tmpB" update_info_utf8 "$metafile" output "$destination"
rm "$tmpB"
rm "$metafile"

# auskommentiert wegen Bug, durch den nur zwei Werte auf einmal editiert werden können
#echo -e "InfoKey: Title\nInfoValue: $title\nInfoKey: Author\nInfoValue: $author\nInfoKey: Subject\nInfoValue: $subject" > "$metafile"

#pdftk "$source" update_info_utf8 "$metafile" output "$destination"

#rm $metafile