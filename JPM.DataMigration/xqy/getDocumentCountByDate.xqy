declare namespace prop = "http://marklogic.com/xdmp/property";

declare function local:uriCountForDate($date as xs:date) as xs:int{
  let $end-date as xs:dateTime := xs:dateTime($date) + xs:dayTimeDuration("P1D") 
  let $start-date as xs:dateTime := xs:dateTime($date)

  let $query := 
  cts:and-query(
  (
    cts:properties-query(cts:element-range-query(xs:QName("prop:last-modified"),">=",$start-date)),
    cts:properties-query(cts:element-range-query(xs:QName("prop:last-modified"),"<",$end-date))
  ))
  return
  fn:count(cts:uris("",(),$query))
};

let $dates := cts:element-values(xs:QName("prop:last-modified"))
let $distinct-dates :=  fn:distinct-values(xs:date($dates))
let $content := 
for $date in $distinct-dates
order by $date descending
return
fn:concat($date,",",local:uriCountForDate($date))

return 
("Date,Doc Count",$content)

