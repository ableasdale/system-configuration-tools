#!/bin/bash

source config.sh

java -cp $CLASSPATH com.marklogic.developer.corb.Manager $AUDIT_CONNECTION_STRING "" deleteDocument.xqy $THREADS getAllMD5URIs.xqy "$MODULES_DIR" "$MODULES_DATABASE" false
