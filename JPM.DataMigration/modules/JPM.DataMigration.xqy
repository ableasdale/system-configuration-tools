module namespace jpm = "jpm:datamigration";

import module namespace constants  = "jpm:datamigration:constants" at "/modules/constants.xqy";          

declare namespace prop="http://marklogic.com/xdmp/property";

declare variable $TEST_START_DATE as xs:dateTime := $constants:TEST_START_DATE;
declare variable $TEST_NUMBER_OF_DAYS as xs:int := $constants:TEST_NUMBER_OF_DAYS;

(: declare variable $MD5_HASH_FILE_PATH := "/tmp/md5.";
declare variable $TEST_MD5_COLL := "/md5.new/"; :)
declare variable $MD5_PRE_REBALANCE_COLL := "md5.pre-rebalance";
declare variable $MD5_POST_REBALANCE_COLL := "md5.post-rebalance";


declare variable $MD5_COLL := "md5";
declare variable $MD5_PRE_ONLY := fn:concat($MD5_COLL,"-pre-only");
declare variable $MD5_POST_ONLY := fn:concat($MD5_COLL,"-post-only");
declare variable $MD5_HASH_MISMATCH := fn:concat($MD5_COLL,"-hash-mismatch");

declare function jpm:testGetURIs(){
  jpm:getURIs($TEST_START_DATE,$TEST_NUMBER_OF_DAYS)
};

declare function jpm:getURIs($start-date as xs:dateTime){
  jpm:getURIs($start-date,1)
};

declare function jpm:getURIs($start-date as xs:dateTime,$no-of-days as xs:int) as xs:string*{
  let $end-date as xs:dateTime := $start-date + $no-of-days * xs:dayTimeDuration("P1D") 

  let $query := 
  cts:and-query(
  (
    cts:properties-query(cts:element-range-query(xs:QName("prop:last-modified"),">=",$start-date)),
    cts:properties-query(cts:element-range-query(xs:QName("prop:last-modified"),"<",$end-date)),
    cts:not-query(cts:collection-query(($MD5_COLL,$MD5_PRE_REBALANCE_COLL,$MD5_POST_REBALANCE_COLL)))
  ))
  return
  cts:uris("",(),$query)
};

declare function jpm:getXQSyncURIs() as xs:string*{
    let $date as xs:dateTime := $constants:XSYNC_EXTRACTION_DATE 
    return
    jpm:getURIs($date,1)
};    

declare function jpm:getAllURIs(){
  let $query := 
    cts:not-query(cts:collection-query(($MD5_COLL,$MD5_PRE_REBALANCE_COLL,$MD5_POST_REBALANCE_COLL)))
  return
  cts:uris("",(),$query)

};

declare function jpm:md5Hash($uris as xs:string*){
  <root>
  {
    for $uri in $uris
    order by $uri
    return
    <item><uri>{$uri}</uri><md5>{xdmp:md5(fn:doc($uri))}</md5></item>
}
</root>
};

declare function jpm:getUniqueSuffix(){
  let $date := fn:substring(xs:string(fn:adjust-date-to-timezone(fn:current-date(),xs:dayTimeDuration("-PT0H"))),1,10)

  let $rand1 as xs:string := xs:string(xdmp:random(1000000))
  let $rand1 := fn:concat(fn:string-join(for $i in (1 to (6 - fn:string-length($rand1))) return "0",""),$rand1)
  let $rand2 as xs:string := xs:string(xdmp:random(1000000))
  let $rand2 := fn:concat(fn:string-join(for $i in (1 to (6 - fn:string-length($rand2))) return "0",""),$rand2)

  return
  fn:string-join(($date,$rand1,$rand2),".")
};

(: declare function jpm:md5FilePath(){
fn:concat($MD5_HASH_FILE_PATH,jpm:getUniqueSuffix(),".xml")
};:)


(: declare function jpm:testSaveHash(){
  for $uri in jpm:getURIs($TEST_START_DATE,10)[1 to 10]
  return
  jpm:addMD5Hash($TEST_MD5_COLL,$uri)  
}; :)

declare private function jpm:order-collections($uri as xs:string){
  for $s in xdmp:document-get-collections($uri)
  order by $s
  return $s
};

declare function jpm:addMD5Hash($coll as xs:string,$uri as xs:string){
  let $hash :=   xdmp:md5( xdmp:quote((
    fn:doc($uri),
    xdmp:document-properties($uri),
    jpm:order-collections($uri))
   ))

  let $md5-file-name := fn:concat($coll,"-",$uri)

  let $node as node() := element jpm:item{element jpm:uri{$uri},element jpm:md5{$hash}}
  
  (: Create eval string :)
  let $string := "xquery version ""1.0-ml"";
       declare variable $URI as xs:string external;
       declare variable $DOC as node() external;
       declare variable $COLL as xs:string external;
       xdmp:document-insert($URI,$DOC,(),($COLL))"
  (: Invoke eval string :)
  let $null := xdmp:eval($string,(xs:QName("URI"),$md5-file-name,xs:QName("DOC"),$node,xs:QName("COLL"),$coll),$constants:AUDIT-DB-EVAL-OPTIONS)
  return $md5-file-name
};

declare function jpm:listCollection($coll){
  for $uri in jpm:fastListCollection($coll)
  order by xdmp:document-get-properties($uri,xs:QName("prop:last-modified")) descending
  return $uri
};

declare function jpm:clearCollection($coll){
  for $uri in jpm:fastListCollection($coll)
  return
  xdmp:document-delete($uri)
};

declare function jpm:fastListCollection($coll){
  cts:uris("",(),cts:collection-query(($coll)))
};

declare function jpm:copyExistingDoc($uri){
    xdmp:document-insert($uri,fn:doc($uri),xdmp:document-get-permissions($uri),xdmp:document-get-collections($uri))
};

declare function jpm:copyExistingDoc($uri,$forest){
    xdmp:document-insert($uri,fn:doc($uri),xdmp:document-get-permissions($uri),xdmp:document-get-collections($uri),0,$forest)
};

declare function jpm:md5PreRebalanceCount(){
fn:count(jpm:fastListCollection($MD5_PRE_REBALANCE_COLL))
};

declare function jpm:md5PostRebalanceCount(){
fn:count(jpm:fastListCollection($MD5_POST_REBALANCE_COLL))
};

declare function jpm:getAllMD5URIs(){
    jpm:fastListCollection($MD5_COLL),jpm:fastListCollection($MD5_PRE_REBALANCE_COLL),jpm:fastListCollection($MD5_POST_REBALANCE_COLL)
};
