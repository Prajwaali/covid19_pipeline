#!/bin/sh

#start
#show the list of sqoop jobs
echo "**** Number Of Jobs ****" 

#1st list command 
sqoop job --list
if [ $? -eq 0 ]
then
	echo "**** Job creation Started **** "

#creating export sqoop job
#export job 1
sqoop job \
-Dhadoop.security.credential.provider.path=jceks://hdfs/user/cloudera/mysql.covid.password \
--create job_ExportCovid19_india \
-- export \
--connect jdbc:mysql://quickstart.cloudera:3306/covid_project \
--username root \
--password-alias mysql.covid.password \
--table Covid19_india \
--staging-table Covid19_india_stage \
--clear-staging-table \
--export-dir /user/cloudera/covid/covid_data/Covid19_india.csv \
--fields-terminated-by ',' 

if [ $? -eq 0 ]
then 
	echo "**** Export Job created for Covid19_india data ****"

#2rd list command 
sqoop job --list
	if [ $? -eq 1 ]
	then
		echo "**** 2nd list command failed ****"
	fi
else
	echo "**** export job 1 not created **** "
fi


#export job 2
sqoop job \
-Dhadoop.security.credential.provider.path=jceks://hdfs/user/cloudera/mysql.covid.password \
--create job_ExportStatewiseTestingDetails \
-- export \
--connect jdbc:mysql://quickstart.cloudera:3306/covid_project \
--username root \
--password-alias mysql.covid.password \
--table StatewiseTestingDetails \
--staging-table StatewiseTestingDetails_stage \
--clear-staging-table \
--export-dir /user/cloudera/covid/covid_data/StatewiseTestingDetails.csv \
--fields-terminated-by ','

if [ $? -eq 0 ]
then 
	echo "**** Export Job created for State data ****"

#3rd list command 
sqoop job --list
	if [ $? -eq 1 ]
	then
		echo "**** 3rd list command failed ****"
	fi
else
	echo "**** export job 2 not created **** "
fi

#creating import sqoop job
#import 1
sqoop job \
-Dhadoop.security.credential.provider.path=jceks://hdfs/user/cloudera/mysql.covid.password \
--create job_ImportCovid19_india \
-- import \
--connect jdbc:mysql://quickstart.cloudera:3306/covid_project \
--username root \
--password-alias mysql.covid.password \
--table Covid19_india \
--warehouse-dir /user/cloudera/covid/ID_out 1>imp_job_covi_wornings 2>imp_job_covi_error \
--split-by Sno \
--incremental append \
--check-column Sno \
--last-value 0 \
--compress

if [ $? -eq 0 ]
then 
	echo "**** Import Job created for Covid19_india data ****"

#4rd list command 
sqoop job --list
	if [ $? -eq 1 ]
	then
		echo "**** 4rd list command failed ****"
	fi
else
	echo "**** import job 1 not created **** "
fi

#import 2
sqoop job \
-Dhadoop.security.credential.provider.path=jceks://hdfs/user/cloudera/mysql.covid.password \
--create job_ImportStatewiseTestingDetails \
-- import \
--connect jdbc:mysql://quickstart.cloudera:3306/covid_project \
--username root \
--password-alias mysql.covid.password \
--table StatewiseTestingDetails \
--warehouse-dir /user/cloudera/covid/SD_out 1>imp_job_state_wornings 2>imp_job_state_error \
--split-by Seq \
--incremental append \
--check-column Seq \
--last-value 0 \
--compress

if [ $? -eq 0 ]
then 
	echo "**** Import Job created for State data ****"

#5th list command 
sqoop job --list
	if [ $? -eq 1 ]
	then
		echo "**** 5th list command failed ****"
	fi
else
	echo "**** import job 2 not created **** "
fi


#code for job creation end	

else
	echo -e "**** 1st list command failed ****"

fi
