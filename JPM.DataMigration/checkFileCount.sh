#!/bin/bash

source config.sh

FILECOUNT=`java -cp $CLASSPATH com.marklogic.xcc.examples.ModuleRunner $CONNECTION_STRING /modules/$CORB_URI_QUERY | head -n 1`

echo Number of files we are processing is $FILECOUNT
