#####从100拿准生产上面的一期数据#####
ftp -i -n 22.12.190.210 <<EOF
user dsadm dsadm
cd /ilms/shdsyy/tmp/imptmp
lcd /ilms
bin
get ilms_exp_F_LN_LN_HIS_BAK.dmp.gz
close
bye
EOF

sleep 100

cd /ilms
gunzip ilms_exp_F_LN_LN_HIS_BAK.dmp.gz
