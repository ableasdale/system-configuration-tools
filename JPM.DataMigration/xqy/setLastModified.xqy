xquery version "1.0-ml";

import module namespace admin = "http://marklogic.com/xdmp/admin" 
      at "/MarkLogic/admin.xqy";

          
let $config := admin:get-configuration()
let $dbid := xdmp:database()
let $config :=  admin:database-set-maintain-last-modified($config, 
        $dbid, fn:false())
let $null := admin:save-configuration($config)
return
fn:concat("Last Modified set to false for ",xdmp:database-name($dbid))
