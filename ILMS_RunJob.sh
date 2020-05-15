[ilmsetl1:dsadm]:/home/dsadm>more ILMS_RunJob.sh 
#!/bin/sh
PROJECT=ILMS
JOB=JOB_CTRL_MAIN
#JOB=batch_test
DATELIST=`more datelist.cfg`
for date_rec in $DATELIST
do
                echo 'rundate: '$date_rec
                ret1=`dsjob -jobinfo $PROJECT $JOB |grep 'Job Status' |grep 'RUN OK (1)' |wc -l`
                ret2=`dsjob -jobinfo $PROJECT $JOB |grep 'Job Status' |grep 'RESET (21)' |wc -l`   
                ret3=`dsjob -jobinfo $PROJECT $JOB |grep 'Job Status' |grep 'NOT RUNNING (99)' |wc -l`
                if [ $ret1 -eq 1 -o ret2  -eq 1 -o ret3  -eq 1 ]
                then
                echo "JOB $JOB RUN OK (1)"
                dsjob -run \
                      -mode NORMAL \
                      -param DT_DATE=$date_rec \
                      -param RUN_FALSE=N \
                      -param DB_PWD=ilms \
                      -param CFG_FILE_NAME=/ilms/etc/ilms.ini \
                      $PROJECT $JOB
                fi
                
        
                ret=1
                while [ $ret -eq 1 ]
                        do
                        sleep 60
                        ret=`dsjob -jobinfo $PROJECT $JOB |grep 'Job Status' |grep 'RUNNING (0)' |wc -l`
                        if [ $ret -eq 1 ]
                        then
                        echo "JOB $JOB RUNNING (0)"
                        fi
                        done
                
                ret=`dsjob -jobinfo $PROJECT $JOB |grep 'Job Status' |grep 'RUN FAILED (3)' |wc -l`
                        if [ $ret -eq 1 ]
                        then
                        echo "JOB $JOB FAILED (3)"
                        exit
                        fi
                
done






[ilmsetl1:dsadm]:/home/dsadm>more datelist.cfg 
20111129
20111130