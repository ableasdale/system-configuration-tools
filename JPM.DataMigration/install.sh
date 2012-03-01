#!/bin/bash

source config.sh

function importModules(){
	for file in `ls modules`
	do
        	insertFile.sh modules modules $file $1
	done
}

# Install Modules
importModules $MODULES_CONNECTION_STRING

importModules $INPUT_MODULES_CONNECTION_STRING

# Set Last Modified to false
java -cp $CLASSPATH com.marklogic.xcc.examples.SimpleQueryRunner $CONNECTION_STRING xqy/setLastModified.xqy
