--get word cloud
select text
from tweets.whole_tweets_clean
where text LIKE '%"+place_name+"%'

--search the tweets that refer to the place name
select count(id)
from tweets.whole_tweets_clean
group by *
where text LIKE '%"+place_name+"%'

--search the tweets that refer to the high freq words
select count(id)
from tweets.whole_tweets_clean
group by *
where text LIKE '%"+high_freq_word+"%'

--search the tweets that refer to both place name and high freq words
select count(id)
from tweets.whole_tweets_clean
group by *
where text LIKE '%"+high_freq_word+"%' AND text LIKE '%"+place_name+"%'