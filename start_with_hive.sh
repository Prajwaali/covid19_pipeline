  GNU nano 2.0.9           File: start_with_hive.sh                   Modified  
                                                                                
#!/bin/sh

beeline -u jdbc:hive2:// -e "show databases;"
if [ $? -eq 0 ]
then
        echo "line executed"   
fi












                                 [ Cancelled ]

