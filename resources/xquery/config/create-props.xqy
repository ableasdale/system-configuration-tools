(: generate per-forest xqsync properties :) 

declare namespace fs="http://marklogic.com/xdmp/status/forest";

let $db-name := xdmp:database-name(xdmp:database())
for $f in xdmp:database-forests(xdmp:database())
let $path := concat('/tmp/xqsync-forest-', xdmp:forest-name($f), '.properties') let $host := xdmp:host-name(xdmp:forest-status($f)/fs:host-id)
return xdmp:save(
  $path,
  text {
    string-join(
    (replace(
      'INPUT_QUERY=cts:uris('''', ''document'', (), (), FOREST',
      'FOREST', string($f)),
     replace(
       replace(
         'INPUT_CONNECTION_STRING=xcc://HOST:9000/DATABASE',
         'HOST', $host),
       'DATABASE', $db-name), ''), codepoints-to-string(10))})
