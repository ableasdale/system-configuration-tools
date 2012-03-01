
(: Add MD5  post re-balance - writes to separate collection :)
(: Executed by Corb :)
import module namespace jpm = "jpm:datamigration" at "/modules/JPM.DataMigration.xqy";

declare variable $URI as xs:string external;

jpm:addMD5Hash($jpm:MD5_POST_REBALANCE_COLL,$URI)
