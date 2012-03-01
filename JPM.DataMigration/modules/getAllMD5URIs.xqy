
(: Corb URI script  - return all MD5 relatedURIs :)

import module namespace jpm = "jpm:datamigration" at "/modules/JPM.DataMigration.xqy";
let $uris := jpm:getAllMD5URIs()
return
(fn:count($uris),$uris)
