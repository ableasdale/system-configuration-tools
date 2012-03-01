#!/bin/bash

source config.sh

file=$1

if [ $2 ] ; then
	connection=$2
else
	connection=$CONNECTION_STRING
fi

java -cp $CLASSPATH com.marklogic.xcc.examples.SimpleQueryRunner $connection $file

