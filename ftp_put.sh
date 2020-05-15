[ilmsetl1:dsadm]:/home/dsadm>more ftp_put.sh 
Date=`date +%Y%m%d%H%M` 
sqlplus ilms/ilms@ilms @get_db_ts_space.sql $Date
df -g >>$Date.lst

ftp -n <<- EOF
open 22.12.190.210
user ilms ilms
passive
bin
cd prod
prompt
put $Date.lst
bye
EOF
rm $Date.lst