
(: Corb URI script  - for large size tests :)
(: Applies to original documents :)

import module namespace jpm = "jpm:datamigration" at "/modules/JPM.DataMigration.xqy";
let $uris := jpm:testGetURIs()
return
(fn:count($uris),$uris)
