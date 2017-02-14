#! /bin/bash

NAME=$1
BARCODESUBREADSET=$(readlink -f $2)
BARCODEFASTA=$(readlink -f $3)
GENOMESIZE=$4
OUTDIR=$(readlink -f $5)
HOST=$6
PORT=$7

MINBCSCORE=45    #Minimum barcode SW alignment score [0-100].  Recommended 45.
MINSUBREADS=5000 #Minimum number of records per barcode (else do not submit job)
SLEEP=5          #minutes to sleep between submitting jobs

PYTHON=/path/to/smrtlink/installdir/private/otherbins/all/bin/python
SPLITPROG=/path/to/splitBarcodeUpload.py
JOBPROG=/path/to/multiplexSubmit.py

$PYTHON $SPLITPROG $BARCODESUBREADSET -n $NAME         \
                                      -b $BARCODEFASTA \
                                      -o $OUTDIR       \
                                      -f $MINBCSCORE   \
                                      -r $MINSUBREADS  \
                                      --host $HOST     \
                                      --port $PORT

$PYTHON $JOBPROG -o $OUTDIR                              \
                 -S $OUTDIR/uploaded_subreadsets.csv     \
                 --HGAP_GenomeLength_str $GENOMESIZE     \
                 -w $SLEEP                               \
                 --host $HOST                            \
                 --port $PORT 
