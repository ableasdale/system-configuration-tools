#!/bin/bash

source config.sh

PROPERTIES="-DINPUT_PACKAGE=$OUTPUT_DIR -Dfile.encoding=UTF-8"
PROPERTIES="$PROPERTIES -DOUTPUT_CONNECTION_STRING=$CONNECTION_STRING"
PROPERTIES="$PROPERTIES -DCOPY_COLLECTIONS=true"
PROPERTIES="$PROPERTIES -DCOPY_PERMISSIONS=true"
PROPERTIES="$PROPERTIES -DCOPY_PROPERTIES=true"
PROPERTIES="$PROPERTIES -DPRINT_CURRENT_RATE=true"
PROPERTIES="$PROPERTIES -DTHREADS=$THREADS"
# PROPERTIES="$PROPERTIES -DLOG_LEVEL=FINEST"

java -cp $CLASSPATH $PROPERTIES com.marklogic.ps.xqsync.XQSync
