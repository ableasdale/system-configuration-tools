(: Remove one file from pre rebalance count :) 
import module namespace jpm  = "jpm:datamigration" at "/modules/JPM.DataMigration.xqy";          

declare function local:mangleMD5($uri){
let $original := fn:doc($uri)
let $colls := xdmp:document-get-collections($uri)
let $internal-uri := $original/jpm:item/jpm:uri/text()
let $md5 := $original/jpm:item/jpm:md5/text()
let $new-doc := element jpm:item{element jpm:uri{$internal-uri},element jpm:md5{fn:concat($md5,"X")}}
return
xdmp:document-insert($uri,$new-doc,(),$colls)
};

xdmp:document-delete(jpm:fastListCollection("md5.pre-rebalance")[200]), 
xdmp:document-delete(jpm:fastListCollection("md5.post-rebalance")[500]),  
local:mangleMD5(jpm:fastListCollection("md5.pre-rebalance")[600])  
