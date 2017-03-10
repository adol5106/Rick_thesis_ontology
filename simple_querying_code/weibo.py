import psycopg2


try:
    conn_string="host='127.0.0.1' dbname='weibo' user='RickZhang_admin' password='47795081'"
    print "Connecting to database\n ->%s" % (conn_string)
    conn = psycopg2.connect(conn_string)
    print conn
    cursor=conn.cursor()
    print "Database Connected!"

    place_name=raw_input("Please type the place name you want to query:")
    file_name=raw_input("Please type the filename you want to export:")
    cursor.execute("create table weibo_"+file_name+" as select id,text,username,lon,lat from sina_weibo where text LIKE '%"+place_name+"%'")
    cursor.execute("copy weibo_"+file_name+" to 'd:/Mongo_Output/placenames/beijing/"+file_name+".csv' WITH CSV HEADER")


except Exception, e:
    print("Connection to '%s'@'%s' failed.")
    print(e)