create table sina_weibo(
id bigint,created_at timestamp,text text,username text,
userdomain text,userlocation text,userid text,usergender text,
lon numeric,lat numeric
);

\copy sina_weibo from 'd:/Mongo_Output/beijing_201310.csv' DELIMITER ',' CSV HEADER;
\copy sina_weibo from 'd:/Mongo_Output/beijing_201311.csv' DELIMITER ',' CSV HEADER;
\copy sina_weibo from 'd:/Mongo_Output/beijing_201312.csv' DELIMITER ',' CSV HEADER;
\copy sina_weibo from 'd:/Mongo_Output/beijing_201312_2.csv' DELIMITER ',' CSV HEADER;
\copy sina_weibo from 'd:/Mongo_Output/beijing_201401.csv' DELIMITER ',' CSV HEADER;
\copy sina_weibo from 'd:/Mongo_Output/beijing_201402.csv' DELIMITER ',' CSV HEADER;
\copy sina_weibo from 'd:/Mongo_Output/beijing_201403.csv' DELIMITER ',' CSV HEADER;
\copy sina_weibo from 'd:/Mongo_Output/beijing_201404.csv' DELIMITER ',' CSV HEADER;
\copy sina_weibo from 'd:/Mongo_Output/beijing_201405.csv' DELIMITER ',' CSV HEADER;
\copy sina_weibo from 'd:/Mongo_Output/beijing_201406.csv' DELIMITER ',' CSV HEADER;
\copy sina_weibo from 'd:/Mongo_Output/beijing_201407.csv' DELIMITER ',' CSV HEADER;
\copy sina_weibo from 'd:/Mongo_Output/beijing_201408.csv' DELIMITER ',' CSV HEADER;
\copy sina_weibo from 'd:/Mongo_Output/beijing_201409.csv' DELIMITER ',' CSV HEADER;

"create table weibo_"+place_name+" as 
select id,text,user_name,lon,lat where text LIKE '%"+place_name+"%'"

"\copy weibo_"+place_name+" to 'd:/Mongo_Output/placenames/"+place_name+".csv"