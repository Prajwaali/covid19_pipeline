#!/bin/sh

#Hive with shell scripting

echo -e "\nDatabases present in the hive are: \n"
beeline -u jdbc:hive2:// -e  "show databases;" #Avaliable databases in the hive

#staging tables creation in hive
beeline -u jdbc:hive2:// -e " create database if not exists covid;" #creating database in if not present hive
if [ $? -eq 0 ]
then 
	echo -e "\nCovid database is created\n"
	beeline -u jdbc:hive2:// -e "show databases;"

	#creating covid19_india external hive table on top of hadoop
	beeline -u jdbc:hive2:// "use covid; create external table IF NOT EXISTS covid.Covid19_india (Sno int, Date string, State_UnionTerritory string,Cured int,Deaths int,Confirmed int) COMMENT 'Table to store All india Covid details' row format delimited fields terminated by ',' stored as orc LOCATION '/user/cloudera/covid/ID_out/Covid19_india';"

	if [ $? -eq 0]
	then
		echo -e "\nStaging Table 1 : Covid19_india created \n"

		#creating statewise covid data external hive table on top of hadoop
		beeline -u jdbc:hive2:// -e "create external table IF NOT EXISTS covid.StatewiseTestingDetails (Seq int,Date string,State string,TotalSamples int,Negative int,Positive int) COMMENT 'Table to store Statewise Covid Test Details' row format delimited fields terminated by ',' stored as orc LOCATION '/user/cloudera/covid/SD_out/StatewiseTestingDetails';"
		if [ $? -eq 0]
		then
			echo -e "\nStaging Table 2 : StatewiseTestingDetails created \n"
			beeline -u jdbc:hive2:// -e "use covid; show tables;"
		else
			echo -e "\nStaging Table 2 : StatewiseTestingDetails not created \n"
		fi	

	else
		echo -e "\nStaging Table 1 : Covid19_india not created \n"
	fi 
	
else
	echo -e "\nCovid database is not created. Need to investigate \n"
fi
