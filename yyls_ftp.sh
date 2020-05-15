#!/bin/bash

set -o nounset
set -o errexit

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

dt_data=$(date -d yesterday '+%Y%m%d')

dt_now_d=$(date '+%d')

dt_2d_ago=$(date -d "2 days ago" '+%Y%m%d')
dt_2d_ago_yy=$(date -d "2 days ago" '+%Y')
dt_2d_ago_md=$(date -d "2 days ago" '+%m%d')

dir_run=/home/expdata/run
dir_down=/home/sftp/yylsftp/download
dir_xindai=/root/data/exp_single/xindai
dir_file_source=/root/data/expdata
dir_file_bak=/root/data
dir_sbs_up=/home/sftp/sbsftp/upload

if [ ! -d  ${dir_down}/${dt_data}/ ]
then
    mkdir -p ${dir_down}/${dt_data}/
fi

for sys_name in $(cat ${dir_run}/sys_yyls_name_list)
do
    for  table_name in $(cat ${dir_run}/yyls_table_name/${sys_name}/table_name.txt)
    do
        if [ -f ${dir_file_source}/${sys_name}/${table_name}_${dt_data}.TXT ]
        then
            cp ${dir_file_source}/${sys_name}/${table_name}_${dt_data}.TXT \
               ${dir_down}/${dt_data}/
        fi
    done
done

sleep 3

if [ -f ${dir_sbs_up}/${dt_data}/rpfx2005_1.010 ]
then
    cp ${dir_sbs_up}/${dt_data}/rpfx2005_1.010 \
       ${dir_down}/${dt_data}/SBS_BALANCESHEET_${dt_data}.TXT
fi
if [ -f ${dir_sbs_up}/${dt_data}/rpax1001_2.010 ]
then
    cp ${dir_sbs_up}/${dt_data}/rpax1001_2.010 \
       ${dir_down}/${dt_data}/rpax1001_2_${dt_data}.TXT
fi
if [ -f ${dir_sbs_up}/${dt_data}/rpax1001_1.010 ]
then
    cp ${dir_sbs_up}/${dt_data}/rpax1001_1.010 \
       ${dir_down}/${dt_data}/rpax1001_1_${dt_data}.TXT
fi
if [ -f ${dir_sbs_up}/${dt_data}/rpdr8583_1.010 ]
then
    cp ${dir_sbs_up}/${dt_data}/rpdr8583_1.010 \
       ${dir_down}/${dt_data}/rpdr8583_1_${dt_data}.TXT
fi
if [ -f ${dir_sbs_up}/${dt_data}/day1001d_1.010 ]
then
    cp ${dir_sbs_up}/${dt_data}/day1001d_1.010 \
       ${dir_down}/${dt_data}/day1001d_1_${dt_data}.TXT
fi

sleep 3

java -jar /home/expdata/exp_single/expview_xindai.jar ${dt_data} && \
    cp ${dir_xindai}/ACPT_CREDENCE_INFO_${dt_data}.TXT ${dir_down}/${dt_data}/

sleep 3

if [ $dt_now_d = "01" ]
then
    if [ -f ${dir_sbs_up}/${dt_data}/dpbcptpiv_1.010 ]
    then
        cp ${dir_sbs_up}/${dt_data}/dpbcptpiv_1.010 \
           ${dir_down}/${dt_data}/dpbcptpiv_1_${dt_data}.TXT
    fi
    if [ -f ${dir_sbs_up}/${dt_data}/dpbcptpiv_2.010 ]
    then
        cp ${dir_sbs_up}/${dt_data}/dpbcptpiv_2.010 \
           ${dir_down}/${dt_data}/dpbcptpiv_2_${dt_data}.TXT
    fi
    if [ -f ${dir_file_source}/nc/GL_DETAIL_${dt_data}.TXT ]
    then
        cp ${dir_file_source}/nc/GL_DETAIL_${dt_data}.TXT \
           ${dir_down}/${dt_data}/
    fi
fi

if [ ! -s ${dir_down}/${dt_data}/ACTCUS_${dt_data}.TXT ]
then
    if [ -f ${dir_file_bak}/sbs/${dt_2d_ago_yy}/${dt_2d_ago_md}/ACTCUS_${dt_2d_ago}.TXT ]
    then
        cp ${dir_file_bak}/sbs/${dt_2d_ago_yy}/${dt_2d_ago_md}/ACTCUS_${dt_2d_ago}.TXT \
           ${dir_down}/${dt_data}/ACTCUS_${dt_data}.TXT
    fi
fi

file_count=$(ls ${dir_down}/${dt_data}/ | wc -w)
if [ ${file_count} = "71" ] || [ ${file_count} = "68" ]
then
    touch  ${dir_down}/${dt_data}/success_${dt_data}.txt
fi