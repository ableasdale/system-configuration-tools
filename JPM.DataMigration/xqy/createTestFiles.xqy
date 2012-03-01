import module namespace jpm = "jpm:datamigration" at "/modules/JPM.DataMigration.xqy";

declare namespace prop = "http://marklogic.com/xdmp/property";


declare variable $NUMBER_OF_FILES as xs:int := 100000;
declare variable $PREFIX as xs:string := "JPM.";
declare variable $DIRECTORY as xs:string := "/data/";
declare variable $DATE_SPREAD as xs:int := 100;

declare function local:createFile(){
    let $itemCount := 1 + xdmp:random(9)
    let $doc := 
    element root{
        for $count in (1 to $itemCount)
        return
        element item{xdmp:random(1000)}
    }
    let $suffix := jpm:getUniqueSuffix()
    let $file-name := fn:concat($DIRECTORY,$PREFIX,$suffix,".xml")
    let $null := xdmp:document-insert($file-name,$doc)
    let $date := fn:current-dateTime() - xdmp:random($DATE_SPREAD) * xs:dayTimeDuration("P1D")    
    let $null := xdmp:document-set-property($file-name,<prop:last-modified>{$date}</prop:last-modified>)
     
    return
    ()
};


(:for $uri in xdmp:directory($DIRECTORY)
return
xdmp:document-delete(fn:base-uri($uri)), :)
for $count in (1 to $NUMBER_OF_FILES)
return
local:createFile()
,
"Files Created",
xdmp:elapsed-time()
