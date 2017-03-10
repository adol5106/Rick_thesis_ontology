import math
import psycopg2


try:
    conn_string="host='127.0.0.1' dbname='Final_Project' user='RickZhang_admin' password='47795081'"
    print "Connecting to database\n ->%s" % (conn_string)
    conn = psycopg2.connect(conn_string)
    print conn
    cursor=conn.cursor()
    print "Database Connected!"

    #search the tweets that refer to the place name
    place_name = raw_input("Please type the place name you want to query:")
    high_freq_word=raw_input("Please type the high freq words you want to query:")
    cursor.execute("select count(id) from tweets.whole_tweets_clean where text LIKE '%"+place_name+"%'")
    place_name_count=cursor.fetchall()
    print place_name_count[0][0]

    cursor.execute("select count(id) from tweets.whole_tweets_clean where text LIKE '%"+high_freq_word+"%'")
    high_freq_word_count=cursor.fetchall()
    print high_freq_word_count[0][0]

    cursor.execute("select count(id) from tweets.whole_tweets_clean where text LIKE '%"+high_freq_word+"%' AND text LIKE '%"+place_name+"%'")
    both_count=cursor.fetchall()
    print both_count[0][0]

    cursor.execute("select count(id) from tweets.whole_tweets_clean")
    total_count=cursor.fetchall()
    print total_count[0][0]

    print math.log((float(both_count[0][0])/float(total_count[0][0]))/((float(place_name_count[0][0])/float(total_count[0][0]))*(float(high_freq_word_count[0][0])/float(total_count[0][0]))))

except Exception, e:
    print("Connection to '%s'@'%s' failed.")
    print(e)