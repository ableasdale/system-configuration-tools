xquery version "1.0-ml";

(:
 :  
 : Generating XQSync properties per host for each forest
 :
:)

declare namespace fs="http://marklogic.com/xdmp/status/forest";

import module namespace admin = 'http://marklogic.com/xdmp/admin'
          at '/MarkLogic/admin.xqy';

declare variable $INPUT-DATABASE as xs:string external;
declare variable $INPUT-PORT as xs:string external;

declare variable $OUTPUT-DATABASE as xs:string external;
declare variable $OUTPUT-PORT as xs:string external; 

declare function local:get-forest-names($h) as xs:string {
text {
for $f in xdmp:database-forests(xdmp:database($INPUT-DATABASE))
where xdmp:forest-status($f)/fs:host-id eq $h
return
xdmp:forest-name($f)}
};

declare function local:all-forest-names-from-host-id($h) as xs:string {
  concat("OUTPUT_FORESTS=", local:get-forest-names($h))
};

for $h in xdmp:hosts()
return 

let $config := admin:get-configuration()
for $f in xdmp:database-forests(xdmp:database($INPUT-DATABASE))
where xdmp:forest-status($f)/fs:host-id eq $h
return xdmp:save(concat("/tmp/",xdmp:host-name($h),"-",xdmp:forest-name($f),".properties"),
text {
concat(string-join((    
    replace(
       replace(
           concat(
            concat('INPUT_CONNECTION_STRING=xcc://admin:admin@host-name:',$INPUT-PORT,'/',$INPUT-DATABASE, codepoints-to-string(10)),
            concat('OUTPUT_CONNECTION_STRING=xcc://admin:admin@host-name:',$OUTPUT-PORT,'/',$OUTPUT-DATABASE),'
INPUT_QUERY=cts:uris("", ("document"), (), (), (forest))
COPY_PERMISSIONS=false
ALLOW_EMPTY_METADATA=true
THREADS=64
PRINT_CURRENT_RATE=true
HASH_MODULE=computehash.xqy
FATAL_ERRORS=false

READ_PERMISSION_ROLES=execute-read-role
UPDATE_PERMISSION_ROLES=insert-update-role

INPUT_BATCH_SIZE=10
USE_IN_FOREST_EVAL=true'),
       'host-name', xdmp:host-name($h)),
       'forest', string($f)), ''), codepoints-to-string(10)), 
local:all-forest-names-from-host-id($h))})