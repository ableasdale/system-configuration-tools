#!/bin/bash

source config.sh

connection=$1
command=$2

echo $command > command.xqy

java -cp $CLASSPATH com.marklogic.xcc.examples.SimpleQueryRunner $connection command.xqy

rm command.xqy
