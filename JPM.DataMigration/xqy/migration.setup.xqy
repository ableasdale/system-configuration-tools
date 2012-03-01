declare namespace jpm = "jpm:datamigration";

import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";
import module namespace info = "http://marklogic.com/appservices/infostudio"  at "/MarkLogic/appservices/infostudio/info.xqy";      

declare namespace error = "http://marklogic.com/xdmp/error";

(:
    This script sets up the modules db, audit db and the XDBC servers required for the data migration    
    
    Run in CQ
    
    Change the value of $TARGET_DATABASE to the target database in the destination system, 
    and the value of $SOURCE_DATABASE to the source database in the source system
    
    Change the value of $SHARE_PATH to a share with enough space
:)

(: These are the only things you need to change :)

declare variable $TARGET-DATABASE := "DCCP";
declare variable $SOURCE-DATABASE := "DCCP";

declare variable $SHARE_PATH := "/space/";

(: Do Not change anything below this line :)

declare variable $DATABASE-PORT := 8123;
declare variable $MODULES-DATABASE-PORT := 8124;
declare variable $MODULES-DATABASE-WEBDAV-PORT := 8125;
declare variable $AUDIT-DATABASE-PORT := 8126;

declare variable $SOURCE-DATABASE-PORT := 8223;

declare variable $MODULES-DB-SUFFIX := "-migration-modules";
declare variable $AUDIT-DB-SUFFIX := "-migration-audit";

declare variable $DUPLICATE_ITEM_CODE  := "ADMIN-DUPLICATEITEM";


declare function jpm:createDatabase($db-name){
    let $configuration := admin:get-configuration()
    return
    if(fn:not(admin:database-exists($configuration,$db-name))) then
    (
        let $null := info:database-create($db-name,1,xdmp:group-name(xdmp:group()),$SHARE_PATH)
        return
        fn:concat("Database ",$db-name," created")
    )
    else
    fn:concat("Database : ",$db-name," already exists. That's OK")
};

declare function jpm:deleteDatabase($db-name){
    let $configuration := admin:get-configuration()
    return
    if(admin:database-exists($configuration,$db-name)) then
    (info:database-delete($db-name,fn:true()),fn:concat("Database : ",$db-name," deleted."))
    else
    fn:concat("Database : ",$db-name," already deleted. That's OK")
};

declare function jpm:getXDBCServerName($db-name,$port-no as xs:int){
    fn:concat(xs:string($port-no),"-",$db-name,"-XDBC")
};

declare function jpm:getWebDAVServerName($db-name,$port-no as xs:int){
    fn:concat(xs:string($port-no),"-",$db-name,"-WebDAV")
};

declare function jpm:createXDBCServer($db-name,$modules-db-name,$port-no as xs:int)
{
    let $server-name := jpm:getXDBCServerName($db-name,$port-no)
    let $configuration := admin:get-configuration()
    return
    if(admin:appserver-exists($configuration,xdmp:group(),$server-name)) then
        fn:concat("Server : ",$server-name," already exists. That's OK")
    else    
    let $configuration := admin:xdbc-server-create(
        $configuration,
        xdmp:group(),
        $server-name,
        "/",
        $port-no,
        xdmp:database($modules-db-name),
        xdmp:database($db-name)
        )
    let $configuration := admin:appserver-set-default-time-limit($configuration,admin:appserver-get-id($configuration, xdmp:group(), $server-name),86400 * 3)
    let $configuration := admin:appserver-set-max-time-limit($configuration,admin:appserver-get-id($configuration, xdmp:group(), $server-name),86400 * 3)
    let $null := admin:save-configuration($configuration)
    return
    fn:concat("Server : ",$server-name," created")    
};


declare function jpm:createWebDAVServer($db-name,$port-no as xs:int)
{
    let $server-name := jpm:getWebDAVServerName($db-name,$port-no)
    let $configuration := admin:get-configuration()
    return
    if(admin:appserver-exists($configuration,xdmp:group(),$server-name)) then
        fn:concat("Server : ",$server-name," already exists. That's OK")
    else    
    let $configuration := admin:webdav-server-create(
        $configuration,
        xdmp:group(),
        $server-name,
        "/",
        $port-no,
        xdmp:database($db-name)
        )
    let $null := admin:save-configuration($configuration)
    return
    fn:concat("Server : ",$server-name," created")    
};

declare function jpm:deleteXDBCServer($db-name,$port-no as xs:int)
{
    let $server-name := jpm:getXDBCServerName($db-name,$port-no)
    let $configuration := admin:get-configuration()
    return
    if(admin:appserver-exists($configuration,xdmp:group(),$server-name)) then
        let $configuration := admin:appserver-delete($configuration,admin:appserver-get-id($configuration,xdmp:group(),$server-name))
        let $null := admin:save-configuration($configuration)
        return
        fn:concat("Server : ",$server-name," deleted")    
    else    
        fn:concat("Server : ",$server-name," does not exist. That's OK")
};

declare function jpm:deleteWebDAVServer($db-name,$port-no as xs:int)
{
    let $server-name := jpm:getWebDAVServerName($db-name,$port-no)
    let $configuration := admin:get-configuration()
    return
    if(admin:appserver-exists($configuration,xdmp:group(),$server-name)) then
        let $configuration := admin:appserver-delete($configuration,admin:appserver-get-id($configuration,xdmp:group(),$server-name))
        let $null := admin:save-configuration($configuration)
        return
        fn:concat("Server : ",$server-name," deleted")    
    else    
        fn:concat("Server : ",$server-name," does not exist. That's OK")
};

declare function jpm:setURILexicon($db-name){
    let $configuration := admin:get-configuration()
    let $db-id := xdmp:database($db-name)
    return
    (
        admin:save-configuration(admin:database-set-uri-lexicon($configuration,$db-id,fn:true())),
        fn:concat("URI lexicon set to true for ",$db-name)
    )
};



declare function jpm:addRangeIndex($qname as xs:QName,$db-name as xs:string)
{         
    let $config := admin:get-configuration()
    let $dbid := xdmp:database($db-name)
    let $namespace := fn:namespace-uri-from-QName($qname)
    let $element-name := fn:local-name-from-QName($qname)        
    let $rangespec := admin:database-range-element-index("string",  $namespace,
                $element-name, "http://marklogic.com/collation/",
        fn:false() )
return 
(
    try{
        let $config := admin:database-add-range-element-index($config, $dbid, $rangespec)
        return
        (
          admin:save-configuration($config),fn:concat("Index on ",xs:string($qname)," created successfully")
        )
    }
    catch($error){
       let $code := $error/error:code/text()
       return
       if ($code = $DUPLICATE_ITEM_CODE) then
       fn:concat("Index on ",xs:string($qname)," already exists - no creation needed")
       else
       fn:concat("!!!Error trying with code ",$code," occurred when trying to create range index on ",xs:string($qname),",you need to investigate!!!")
    }
)
};


let $mode := "create"
let $modules-database-name := fn:concat($TARGET-DATABASE,$MODULES-DB-SUFFIX)
let $audit-database-name := fn:concat($TARGET-DATABASE,$AUDIT-DB-SUFFIX)
return
(
    if($mode = "create") then
    (
        jpm:createDatabase($modules-database-name),   
        jpm:createDatabase($audit-database-name),
        jpm:setURILexicon($audit-database-name),
        jpm:addRangeIndex(xs:QName("jpm:uri"),$audit-database-name),
        jpm:addRangeIndex(xs:QName("jpm:md5"),$audit-database-name),
        jpm:createXDBCServer($TARGET-DATABASE,$modules-database-name,$DATABASE-PORT),
        jpm:createXDBCServer($SOURCE-DATABASE,$modules-database-name,$SOURCE-DATABASE-PORT),
        jpm:createXDBCServer($modules-database-name,$modules-database-name,$MODULES-DATABASE-PORT),
        jpm:createXDBCServer($audit-database-name,$modules-database-name,$AUDIT-DATABASE-PORT),
        jpm:createWebDAVServer($modules-database-name,$MODULES-DATABASE-WEBDAV-PORT)

    )        
    else if($mode = "delete") then
    (
        jpm:deleteXDBCServer($TARGET-DATABASE,$DATABASE-PORT),
        jpm:deleteXDBCServer($SOURCE-DATABASE,$SOURCE-DATABASE-PORT),
        jpm:deleteXDBCServer($modules-database-name,$MODULES-DATABASE-PORT),
        jpm:deleteXDBCServer($audit-database-name,$AUDIT-DATABASE-PORT),             
        jpm:deleteWebDAVServer($modules-database-name,$MODULES-DATABASE-WEBDAV-PORT),
        jpm:deleteDatabase($modules-database-name),
        jpm:deleteDatabase($audit-database-name)         
    )
    else()
)