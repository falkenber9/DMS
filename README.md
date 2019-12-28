
Document Management System (DMS)
================================

Collection of bash scripts to run OCR on all scanned PDF documents (e.g. from paper) within a directory ``incoming``. The output is copied into a folder structure ``DMS/<current-year>`` that can be indexed by any PDF-capable file indexer (such a KDEs Baloo).

## Main Script / Usage
```
./import-documents.sh
```

## Dependencies
```
ocrmypdf
tesseract
```

## LICENSE
MIT License.