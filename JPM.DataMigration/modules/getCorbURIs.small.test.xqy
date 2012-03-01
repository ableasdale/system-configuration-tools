
(: Corb URI script  - for small size tests :)
(: Applies to original documents :)

import module namespace jpm = "jpm:datamigration" at "/modules/JPM.DataMigration.xqy";
let $uris := jpm:testGetURIs()[1 to 10]
return
(fn:count($uris),$uris)
