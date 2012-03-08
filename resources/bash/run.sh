#!/bin/bash
for i in *.properties; do
	java -Xincgc -Xmx5012m -Dfile.encoding=UTF-8 -cp xcc.jar:xstream.jar:xqsync.jar:xpp3.jar com.marklogic.ps.xqsync.XQSync $i
done
