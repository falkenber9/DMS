#!/bin/bash
#
# Extrahiert aus allen PDF Dokumenten im aktuellen Verzeichnis seitenweise das Bild,
# setzt dessen DPI Wert auf 300 und packt sie wieder in entsprechende PDFs ein
# Resultate finden sich in $outdir
# Es wird kein Up-sampling durchgeführt.

# Grund für dieses Script: Ist in einem gescannten Bild kein korrekter DPI-Wert angegeben,
# so wird bei der Umwandlung in PDF eine Dichte von 72dpi angenommen.
# Hat das Bild in wirklichkeit eine höhere Auflösung, so wird die Dimension
# der PDF-Seite entsprechend vergrößert. Bei 300dpi ist so eine PDF Seite 
# ca. 4.5-fach so groß. Der dumme Brother-Treiber druckt das Dokument dann
# auch so riesig aus... als Poster -.-

# Die Abmessungen der PDF-Seiten (in Einheit pt, nicht px!) können mit
# folgender Kommandozeile für einen Ordner ausgegeben werden:
#
# for myfile in *.pdf; do identify -format "%w %h\n" "$myfile""[0]"; echo "$myfile"; done
#
# Dabei wird jeweils nur die Dimension der ersten Seite [0] ausgegeben.

DPI=300

tmpdir=tmp
outdir=output

mkdir $tmpdir
mkdir $outdir

for sourcefile in *.[Pp][Dd][Ff]; do
#    filename=(`basename "${sourcefile%.[Pp][Dd][Ff]}"`)
    echo $sourcefile
    convert -units PixelsPerInch "$sourcefile" -density $DPI "$tmpdir/$sourcefile.jpg"
    convert "$tmpdir/*.jpg" "$outdir/$sourcefile"
    rm $tmpdir/*.jpg
done