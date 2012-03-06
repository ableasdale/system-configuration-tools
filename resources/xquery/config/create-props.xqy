(: generate per-forest xqsync properties :) 

declare namespace fs="http://marklogic.com/xdmp/status/forest";

declare variable $DB-NAME as xs:string external;
declare variable $PATH-SEGMENT as xs:string external;
declare variable $PORT as xs:string external;
(: declare variable $DB-NAME as xs:string external; :)


(: let $db-name := xdmp:database-name(xdmp:database()) :)
for $f in xdmp:database-forests(xdmp:database())
let $path := concat($PATH-SEGMENT, xdmp:forest-name($f), '.properties') let $host := xdmp:host-name(xdmp:forest-status($f)/fs:host-id)
return xdmp:save(
  $path,
  text {
    string-join(
    (replace(
      'INPUT_QUERY=cts:uris('''', ''document'', (), (), FOREST',
      'FOREST', string($f)),
     replace(
       replace(
         concat("INPUT_CONNECTION_STRING=xcc://HOST:",$PORT,"/DATABASE"),
         'HOST', $host),
       'DATABASE', $DB-NAME), ''), codepoints-to-string(10)),"
READ_PERMISSION_ROLES=ODSExecuteReadRole
UPDATE_PERMISSION_ROLES=ODSInsertUpdateRole"})