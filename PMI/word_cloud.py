import math
import psycopg2
import matplotlib.pyplot as plt; plt.rcdefaults()
import numpy as np
import matplotlib.pyplot as plt
from collections import Counter
import csv

from wordcloud import WordCloud, STOPWORDS
import datetime


try:
    conn_string="host='127.0.0.1' dbname='Final_Project' user='RickZhang_admin' password='47795081'"
    print "Connecting to database\n ->%s" % (conn_string)
    conn = psycopg2.connect(conn_string)
    print conn
    cursor=conn.cursor()
    print "Database Connected!"

    #get the semantic meaning
    place_name = raw_input("Please type the place name you want to query:")
    wordcloud_text=''
    cursor.execute("select text from tweets.whole_tweets_clean where text LIKE '%"+place_name+"%'")
    word_records=cursor.fetchall()
    for m in range(len(word_records)):
        wordcloud_text += word_records[m][0]
    stopwords = set(STOPWORDS)
    stopwords_list = ["https", "said", "will","@","at","the","go", "come", "today", "day", "going", "good", "California", "San", "Diego", "CA", str(place_name)]
    for k in range(len(stopwords_list)):
        stopwords.add(stopwords_list[k])
    wordcloud = WordCloud(background_color="white", max_font_size=50, max_words=2000, stopwords=stopwords)
    wordcloud.generate(wordcloud_text)
    plt.figure()
    plt.imshow(wordcloud)
    plt.axis("off")
    plt.title('The most frequent words that have been mentioned in tweets about ' + place_name)
    plt.show()
    word_freq_list=Counter(wordcloud_text.split()).most_common()
    with open("word_freq_list.csv","wb") as f:
        writer=csv.writer(f)
        writer.writerows(word_freq_list)



except Exception, e:
    print("Connection to '%s'@'%s' failed.")
    print(e)