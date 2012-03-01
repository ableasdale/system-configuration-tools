#!/bin/bash

source config.sh

java -cp $CLASSPATH com.marklogic.developer.corb.Manager $CONNECTION_STRING "" Corb.MD5.Post.Rebalance.xqy $THREADS $CORB_URI_QUERY "$MODULES_DIR" $MODULES_DATABASE	false
