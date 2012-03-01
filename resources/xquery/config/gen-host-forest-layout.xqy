xquery version "1.0-ml";

declare namespace fs="http://marklogic.com/xdmp/status/forest";

import module namespace admin = 'http://marklogic.com/xdmp/admin'
          at '/MarkLogic/admin.xqy';

(: 
 :     Generic script for gettting a host/forests layout for a given database spread over a cluster
:)

text {
"xquery version '1.0-ml';

import module namespace admin = 'http://marklogic.com/xdmp/admin'
          at '/MarkLogic/admin.xqy';

let $config := admin:get-configuration()
",
for $h in xdmp:hosts()
return 

let $config := admin:get-configuration()
for $f in xdmp:database-forests(xdmp:database("YOUR_DATABASE_HERE"))
where xdmp:forest-status($f)/fs:host-id eq $h
return 
string-join((    
    replace(
       replace('let $config := admin:forest-create($config, F, H, "C:\TEMP")', 
       'H', string($h)),
       'F', string(xdmp:forest-name($f))), ''), codepoints-to-string(10)),
"return admin:save-configuration($config)"
}