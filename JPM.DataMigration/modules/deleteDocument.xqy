
(: Delete a document :)
(: Executed by Corb :)
import module namespace jpm = "jpm:datamigration" at "/modules/JPM.DataMigration.xqy";

declare variable $URI as xs:string external;

xdmp:document-delete($URI)
