 

filename=$1

JHOVE="/usr/lib/jhove/bin/JhoveApp.jar" # java SW for validating the final PDF/A
JHOVE_CFG="/usr/lib/jhove/conf/jhove.conf"      # location of the jhove config file

FILE_VALIDATION_LOG="/tmp/pdf-validation.log"

java -jar "$JHOVE" -c "$JHOVE_CFG" -m PDF-hul "$filename" > "$FILE_VALIDATION_LOG"
grep -i "Status|Message" "$FILE_VALIDATION_LOG" # summary of the validation
echo "The full validation log is available here: \"$FILE_VALIDATION_LOG\""
# check the validation results
pdf_valid=1
grep -i 'ErrorMessage' "$FILE_VALIDATION_LOG" && pdf_valid=0
grep -i 'Status.*not valid' "$FILE_VALIDATION_LOG" && pdf_valid=0
grep -i 'Status.*Not well-formed' "$FILE_VALIDATION_LOG" && pdf_valid=0
! grep -i 'Profile:.*PDF/A-1' "$FILE_VALIDATION_LOG" > /dev/null && echo "PDF file profile is not PDF/A-1" && pdf_valid=0
[ $pdf_valid -ne 1 ] && echo "Output file: The generated PDF/A file is INVALID ($filename)"
[ $pdf_valid -eq 1 ] && echo "Output file: The generated PDF/A file is VALID ($filename)"

rm $FILE_VALIDATION_LOG