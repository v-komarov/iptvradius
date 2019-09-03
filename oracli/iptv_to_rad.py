#!/usr/bin/python
import sys, os
import datetime
import MySQLdb
DB_HOST="freeradiusdb"
DB_USER="freeradius"
DB_PASS="freeradius"
DB_DATABASE="radius"



print 'start: ', datetime.datetime.now()

try:
  import cx_Oracle
except ImportError,info:
  print "Import Error:",info
  sys.exit()

try:
  with cx_Oracle.connect('ap/ap@192.168.115.21/onyma') as conn:
    try:

      cur = conn.cursor()
      q="""
          SELECT        
              replace(REGEXP_SUBSTR(MM.SITENAME,'[0-9]+'),'','') as cid,
              UPPER(REPLACE(AP."VALUE", '.')) as mac,
              0 as pid,
              to_char(DS.BEGDATE, 'yyyy-mm-dd') as date1,
              to_char(DS.ENDDATE, 'yyyy-mm-dd') as date2,
              DS.DMID as sid,
              AP.CLOSED as status
            FROM DOG_SERV DS

              LEFT JOIN MAP_MAIN MM2 ON MM2.DMID = DS.DMID
              LEFT JOIN MAP_MAIN MM ON replace(REGEXP_SUBSTR(MM2.SITENAME,'[0-9]+'),'','') = replace(REGEXP_SUBSTR(MM.SITENAME,'[0-9]+'),'','')

              JOIN AUTH_SPEC_PARAMS AP On AP.DMID = MM.DMID AND AP.ATTRCOD = 203

            WHERE MM.SITENAME LIKE 'tv%' AND MM.DELDATE IS NULL 
              AND DS.BEGDATE < SYSDATE
              AND (DS.ENDDATE > SYSDATE OR DS.ENDDATE is null) 
              AND AP.CLOSED!=4
          UNION
            SELECT DISTINCT
             replace(REGEXP_SUBSTR(MM.SITENAME,'[0-9]+'),'','') as cid,
             CASE
             WHEN AP.ATTRCOD = 203 THEN UPPER(REPLACE(AP."VALUE",'.'))
             ELSE SUBSTR(UPPER(REPLACE(AP."VALUE",':')),0,12)
             END AS mac,
             0 AS pid,
             to_char(DS.BEGDATE, 'yyyy-mm-dd') as date1,
             to_char(DS.ENDDATE, 'yyyy-mm-dd') as date2,
             DS.DMID as sid,
             AP.CLOSED as status
             FROM MAP_MAIN MM
             LEFT JOIN DOG_SERV DS ON MM.DMID = DS.DMID
             LEFT JOIN MAP_MAIN MM2 ON replace(REGEXP_SUBSTR(MM.SITENAME,'[0-9]+'),'','') = replace(REGEXP_SUBSTR(MM2.SITENAME,'[0-9]+'),'','')
             JOIN AUTH_SPEC_PARAMS AP On AP.DMID = MM2.DMID 
             WHERE MM.sitename LIKE 'tv%' 
             AND MM.deldate IS NULL
             AND MM2.deldate IS NULL
             AND DS.ENDDATE IS NULL
             AND (AP.ATTRCOD = 203 OR AP.ATTRCOD = 205)
             AND DS.BEGDATE < SYSDATE
             AND (DS.ENDDATE > SYSDATE OR DS.ENDDATE is null) 
             AND AP.CLOSED!=4
             AND AP."VALUE" IS NOT NULL
        """

      cur.execute(q)

      mysql_conn = MySQLdb.connect(host= DB_HOST, user=DB_USER, passwd=DB_PASS, db=DB_DATABASE)
      mysql_x = mysql_conn.cursor()

      mysql_x.execute("TRUNCATE TABLE radbilling")
      for col1, col2, col3, col4, col5, col6, col7 in cur.fetchall():
          if col2 != None:
              mysql_x.execute("""INSERT INTO radbilling (cid,mac,pid,date1,date2,sid,status) VALUES (%s,%s,%s,%s,%s,%s,%s)""", (col1, col2, col3, col4, col5, col6, col7))

      mysql_conn.commit()

      cur.close()
      mysql_conn.close()

    except cx_Oracle.DatabaseError, info:
      print "DB Error:", info
      cur.close()
      exit(0)

  print 'end:   ', datetime.datetime.now()

except cx_Oracle.DatabaseError, info:
  print "Logon Error:", info
  exit(0)
