#!/bin/bash

# Don't change the two items below
export MODULES_DB_SUFFIX=-DataMigration-Modules

# Credentials for target system
export HOST=rh5-intel64-8
export ADMIN_USER=admin
export ADMIN_PASSWORD=admin

# Credentials for source system
export INPUT_HOST=$HOST
export INPUT_ADMIN_USER=$ADMIN_USER
export INPUT_ADMIN_PASSWORD=$ADMIN_PASSWORD


# TARGET_DATE only used for directory matching here
export TARGET_DATE=2012-12-01
export OUTPUT_AREA=/space/JP.DataMigration.KenTune
export THREADS=32

# Location of modules db, and directory in which modules are found
export MODULES_DATABASE=DCCP
export MODULES_DIR=/modules/

# Query that drives rebalancing and MD5 generation
# When running for real, set to getAllURIs.xqy 
export CORB_URI_QUERY=getCorbURIs.large.test.xqy
# export CORB_URI_QUERY=getAllURIs.xqy

# Do not alter anything beyond this point #

# Port numbers below can be changed, but only in consultation with MarkLogic
export PATH=$PATH:.

export PORT=8123
export MODULES_DB_PORT=8124
export AUDIT_DB_PORT=8126
export SOURCE_PORT=8223
export CONNECTION_STRING=xcc://$ADMIN_USER:$ADMIN_PASSWORD@$HOST:$PORT
export MODULES_CONNECTION_STRING=xcc://$ADMIN_USER:$ADMIN_PASSWORD@$HOST:$MODULES_DB_PORT
export AUDIT_CONNECTION_STRING=xcc://$ADMIN_USER:$ADMIN_PASSWORD@$HOST:$AUDIT_DB_PORT
export INPUT_CONNECTION_STRING=xcc://$ADMIN_USER:$INPUT_ADMIN_PASSWORD@$INPUT_HOST:$SOURCE_PORT

export INPUT_MODULES_CONNECTION_STRING=xcc://$ADMIN_USER:$INPUT_ADMIN_PASSWORD@$INPUT_HOST:$MODULES_DB_PORT


export OUTPUT_DIR=$OUTPUT_AREA/$TARGET_DATE
export OUTPUT_PACKAGE=$OUTPUT_DIR/DCPP.zip

export CLASSPATH=lib/xqsync.jar:lib/marklogic-xcc-4.2.8.jar:lib/xstream-1.4.2.jar:lib/xpp3-1.1.4c.jar:lib/corb.jar:lib/marklogic-xcc-examples-4.2.7.jar

export ADMIN_PORT=22020
export ADMIN_CONNECTION_STRING=xcc://$ADMIN_USER:$ADMIN_PASSWORD@$HOST:$ADMIN_DB_PORT
