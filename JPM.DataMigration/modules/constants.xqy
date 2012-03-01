module namespace jpm-constants = "jpm:datamigration:constants";

(: Ignore this if you are editting - these really are constants :)
declare variable $AUDIT-DB-SUFFIX := "-migration-audit";
declare variable $AUDIT-DB-NAME := fn:concat(xdmp:database-name(xdmp:database()),$AUDIT-DB-SUFFIX);

declare variable $AUDIT-DB-EVAL-OPTIONS :=
    <options xmlns="xdmp:eval">
        <database>{xdmp:database($AUDIT-DB-NAME)}</database>
    </options>;

(: Edit these items ( if reqd ) :)
declare variable $TEST_START_DATE as xs:dateTime := xs:dateTime("2010-05-06T00:00:00Z") ;
declare variable $TEST_NUMBER_OF_DAYS as xs:int := 10   ;

declare variable $XSYNC_EXTRACTION_DATE as xs:dateTime := xs:dateTime(xs:date("2010-05-01"));
