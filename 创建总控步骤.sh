[ilmsetl1:dsadm]:/home/dsadm/ILMS_SHELL>more STEP.sh 
#ILMSV2���ݿ��û�
ILMS_DB_USR=ILMSV2
ILMS_DB_PWD=ILMSV2
ILMS_DB_INSTANCE=ILMS
#ILMSGM���ݿ��û�
ILMSGM_DB_USR=ILMSGM
ILMSGM_DB_PWD=ILMSGM
ILMSGM_DB_INSTANCE=ILMS

###step 1###
echo "��һ��:��������Ŀ¼(yes/no)?"
read answer
if [ "$answer" == "yes" ];then
        echo "Your input is yes..."
        "begin time: `date +%Y-%m-%d\ %H:%M:%S` "
  cd /ilms/data
  mkdir -p DATA
  mkdir -p STG
  mkdir -p REJF
  mkdir -p DEAL
  cd DEAL
  mkdir -p CC
  mkdir -p DM
  mkdir -p EC
  mkdir -p SC
  cd ..
  mkdir -p SCHE
  cd SCHE
  cp /home/dsadm/ILMS_SHELL/SCHE/* .
  cd
  cd /IBM/InformationServer/Server/Configurations
  cp /home/dsadm/ILMS_SHELL/NODE/* .
  cd 
  cd /ilms/bkrs
  cp /home/dsadm/ILMS_SHELL/*.tar .
  tar xvf backup.tar
  cd /home/dsadm/ILMS_SHELL
  echo "end time: `date +%Y-%m-%d\ %H:%M:%S` "
else
  echo "input is $answer,������һ��:��������Ŀ¼"
fi
echo ""
echo ""
echo "��һ�����!"
echo "*************************************************************"

###step 2###
echo "�ڶ���:����ILMSGM�ܿ����ݿ����ʼ�����ݱ���ʼ������(yes/no)?"
read answer
if [ "$answer" == "yes" ];then
        echo "Your input is yes..."
        "begin time: `date +%Y-%m-%d\ %H:%M:%S` "
WORK_DATE=`sqlplus -silent $ILMSGM_DB_USR/$ILMSGM_DB_PWD@$ILMSGM_DB_INSTANCE <<!
    set pagesize 0 feedback off verify off heading off echo off define off;
    @ILMSGM_CREATE_DB.sql;
    @ILMSGM_INIT_DATA.sql;
    @ILMSGM_EXEC_SP.sql;
!`
echo "$WORK_DATE"
  echo "end time :`date +%Y-%m-%d\ %H:%M:%S` "
else
  echo "input is $answer,�����ڶ���:����ILMSGM�ܿ����ݿ����ʼ�����ݱ���ʼ������"
fi
echo ""
echo ""
echo "�ڶ������!"
echo "*************************************************************"

###step 3###
echo "������:����ILMSV2��ز����ݿ��(yes/no)?"
read answer
if [ "$answer" == "yes" ];then
        echo "Your input is yes..."
        "begin time: `date +%Y-%m-%d\ %H:%M:%S` "
WORK_DATE=`sqlplus -silent $ILMS_DB_USR/$ILMS_DB_PWD@$ILMS_DB_INSTANCE <<!
    set pagesize 0 feedback off verify off heading off echo off define off;
    @ILMSV2_CREATE_DB.sql;
    @ILMSV2_INIT_DATA.sql;
    @ILMSV2_EXEC_SP.sql;
!`
echo "$WORK_DATE"
  echo "end time: `date +%Y-%m-%d\ %H:%M:%S` "
else
  echo "input is $answer,����������ز����ݿ��"
fi
echo ""
echo ""
echo "���������!"
echo "*************************************************************"