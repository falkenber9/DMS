#/bin/bash

scriptpath=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
mydate=$(date +'%Y')

source=$scriptpath/../incoming
destination=$scriptpath/../documents/$mydate

tmpfile="/tmp/import-documents-tempfile.pdf"

OCRmyPDFParams="-c -d -l deu"
# -d

printError=true
printWarning=true
printInfo=true
printDebug=true

RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
PURPLE='\033[1;35m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

proceedcounter=0
succeedcounter=0

debug () {
    if [ "$printDebug" = true ]; then
        echo -e "${CYAN}[D]${NC} $1"
    fi
}

info () {
    if [ "$printInfo" = true ]; then
        echo -e "${GREEN}[I]${NC} $1"
    fi
}

warn () {
    if [ "$printWarning" = true ]; then
        echo -e "${YELLOW}[W]${NC} $1"
    fi
}

error () {
    if [ "$printError" = true ]; then
        echo -e "${RED}[E]${NC} $1"
    fi
}


debug "Quellverzeichnis: $source"
debug "Zielverzeichnis: $destination"

# Zielverzeichnis ggf anlegen
if [ ! -d "$destination" ]; then
    info "Erstelle neues Zielverzeichnis: $destination"
    mkdir "$destination"
else
    debug "Zielverzeichnis existiert"
fi

# Alle PDF Dateien in incoming-Verzeichnis abarbeiten
cd $source
if [ $? -eq 0 ]; then
    for sourcefile in *.[Pp][Dd][Ff]; do
        if [ -e "$sourcefile" ]; then
            proceedcounter=$[proceedcounter + 1]
            info "Verarbeite Datei: $sourcefile"
            destinationfile="$destination/${sourcefile%.[Pp][Dd][Ff]}.pdf"
            debug "Zieldatei: $destinationfile"
            if [ ! -e "$destinationfile" ]; then
                #OCRmyPDF.sh $OCRmyPDFParams "$sourcefile" "$tmpfile"
                echo "ocrmypdf $OCRmyPDFParams $sourcefile $tmpfile"
                ocrmypdf $OCRmyPDFParams "$sourcefile" "$tmpfile"
                if [ $? -eq 0 ]; then
                    debug "OCRmyPDF erfolgreich bei: $sourcefile"
                    debug "Füge Metadaten (Titel, Autor, Betreff) in PDF ein"
                    $scriptpath/./add-metadata.sh "$tmpfile" "$destinationfile" "${sourcefile%.[pP][dD][fF]}"
                    rm "$tmpfile"
                    if [ -f "$destinationfile" ]; then
                        succeedcounter=$[succeedcounter + 1]
                        debug "Lösche Original: $sourcefile"
                        rm -f "$sourcefile"
                    else
                        error "Keine Ziel-Datei generiert: $sourcefile"
                    fi
                else
                    error "Texterkennung fehlgeschlagen ($?) für: $sourcefile"
                fi
            else
                warn "Datei übersprungen, weil am Zielort existent: $destinationfile"
            fi
        else
            info "Datei nicht gefunden: $sourcefile"
        fi
    done
fi

echo "Import abgeschlossen: $succeedcounter von $proceedcounter Dokumenten erfolgreich importiert."
