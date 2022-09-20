show databases;

--creating database in hive
create database if not exists Covid;
show databases;
use covid;

--creating external hive tables on top of hadoop
create external table IF NOT EXISTS Covid19_india 
(Sno int,
Date string,
State_UnionTerritory string,
Cured int,
Deaths int,
Confirmed int)
COMMENT 'Table to store All india Covid details'
row format delimited fields terminated by ','
stored as orc
LOCATION '/user/cloudera/covid/ID_out/Covid19_india';

show tables;

create external table IF NOT EXISTS StatewiseTestingDetails
(Seq int,
Date string,
State string,
TotalSamples int,
Negative int,
Positive int)
COMMENT 'Table to store Statewise Covid Test Details'
row format delimited
fields terminated by ','
stored as orc
LOCATION '/user/cloudera/covid/SD_out/StatewiseTestingDetails';

show tables;
