
(: Corb URI script  - for large size tests :)
(: Get all URIs of documents being migrated :)
import module namespace jpm = "jpm:datamigration" at "/modules/JPM.DataMigration.xqy";
let $uris := jpm:getAllURIs()
return
(fn:count($uris),$uris)
