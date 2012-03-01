module namespace reporting = "jpm:datamigration:reporting";

import module namespace jpm = "jpm:datamigration" at "/modules/JPM.DataMigration.xqy";

declare variable $URI-Q as xs:QName := xs:QName("jpm:uri");
declare variable $MD5-Q as xs:QName := xs:QName("jpm:md5");


declare variable $PRE-REBALANCE-COLL-QUERY := cts:collection-query($jpm:MD5_PRE_REBALANCE_COLL);

declare variable $POST-REBALANCE-COLL-QUERY := cts:collection-query($jpm:MD5_POST_REBALANCE_COLL);

declare variable $PRE-REBALANCE-URIS := cts:element-values($URI-Q,"",(),$PRE-REBALANCE-COLL-QUERY);
declare variable $POST-REBALANCE-URIS := cts:element-values($URI-Q,"",(),$POST-REBALANCE-COLL-QUERY);

declare function reporting:uriCheck(){
 let $map1 := cts:element-values($reporting:URI-Q,"",("map"),$reporting:PRE-REBALANCE-COLL-QUERY)
 let $map2 := cts:element-values($reporting:URI-Q,"",("map"),$reporting:POST-REBALANCE-COLL-QUERY)

    return
    (
    "Files appearing pre-rebalance, but not post-rebalance : ",
    "========================================================",
    "",    
    map:keys($map1 - $map2),
    "Files appearing post-rebalance, but not pre-rebalance : ",
    "========================================================",
    "",
    map:keys($map2 - $map1)
    )
    
};

declare function reporting:hashMismatch(){
    let $pre-rebalance-md5 := cts:element-values($reporting:MD5-Q,"",("map"),$reporting:PRE-REBALANCE-COLL-QUERY)
    let $post-rebalance-md5 := cts:element-values($reporting:MD5-Q,"",("map"),$reporting:POST-REBALANCE-COLL-QUERY)
    let $pre-rebalance-break := map:keys($pre-rebalance-md5 - $post-rebalance-md5)
    let $post-rebalance-break := map:keys($post-rebalance-md5 - $pre-rebalance-md5)
    let $md5-pre-query := cts:element-range-query($reporting:MD5-Q,"=",($pre-rebalance-break))
    let $pre-docs := cts:uris("",(),$md5-pre-query)
    let $md5-post-query := cts:element-range-query($reporting:MD5-Q,"=",($post-rebalance-break))
    let $post-docs := cts:uris("",(),$md5-post-query)
    let $pre-map := map:map()
    let $post-map := map:map()
    let $null := for $doc in $pre-docs return map:put($pre-map,cts:element-values($reporting:URI-Q,"",(),cts:document-query($doc)),1)
    let $null := for $doc in $post-docs return map:put($post-map,cts:element-values($reporting:URI-Q,"",(),cts:document-query($doc)),1)
    return
    map:keys($pre-map * $post-map)
};

declare function reporting:md5report(){
reporting:uriCheck(),
"Files differing post-rebalance/pre-rebalance : ",
"========================================================",
"",
reporting:hashMismatch() 
};

