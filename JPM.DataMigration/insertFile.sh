#!/bin/bash

source config.sh

xqy_dir=$1
db_dir=$2
xqy_file=$3
connection=$4

content=`cat $xqy_dir/$xqy_file`
string=xdmp:document-insert\(\"/$xqy_dir/$xqy_file\",text{\'"$content"\'}\)\,\"Imported\ $xqy_file\"

echo "$string" > /tmp/$xqy_file
executeScript.sh /tmp/$xqy_file $connection 

rm /tmp/$xqy_file
