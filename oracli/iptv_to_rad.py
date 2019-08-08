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
                 CASE WHEN (DS.SERVID = 1706) THEN 0 ELSE 999 
              END as pid,
              to_char(DS.BEGDATE, 'yyyy-mm-dd') as date1,
              to_char(DS.ENDDATE, 'yyyy-mm-dd') as date2,
              DS.DMID as sid,
              AP.CLOSED as status
            FROM DOG_SERV DS

              LEFT JOIN MAP_MAIN MM2 ON MM2.DMID = DS.DMID
              LEFT JOIN MAP_MAIN MM ON replace(REGEXP_SUBSTR(MM2.SITENAME,'[0-9]+'),'','') = replace(REGEXP_SUBSTR(MM.SITENAME,'[0-9]+'),'','')

              JOIN AUTH_SPEC_PARAMS AP On AP.DMID = MM.DMID AND AP.ATTRCOD = 31

            WHERE DS.SERVID in (1706)
              AND DS.BEGDATE < SYSDATE
              AND (DS.ENDDATE > SYSDATE OR DS.ENDDATE is null) 
              AND AP.CLOSED!=4
                  """

      cur.execute(q)

      mysql_conn = MySQLdb.connect(host= DB_HOST, user=DB_USER, passwd=DB_PASS, db=DB_DATABASE)
      mysql_x = mysql_conn.cursor()

      mysql_x.execute("TRUNCATE TABLE radbilling")
      #mysql_conn.commit()
      for col1, col2, col3, col4, col5, col6, col7 in cur.fetchall():
        if(col5 != None):
          mysql_x.execute("""INSERT INTO radbilling (cid,mac,pid,date1,date2,sid,status) VALUES (%s,%s,%s,%s,%s,%s,%s)""", (col1, col2, col3, col4, col5, col6, col7))
        else:
          mysql_x.execute("""INSERT INTO radbilling (cid,mac,pid,date1,sid,status) VALUES (%s,%s,%s,%s,%s,%s)""", (col1, col2, col3, col4, col6, col7))

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
