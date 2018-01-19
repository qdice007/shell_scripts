#!/bin/bash

# 第一个冒号表示不显示出错信息
while getopts :ab:cd opt
do
    case "$opt" in
        a)
            echo "Found the -a option"
            ;;
        b)
            echo "Found the -b option, with value $OPTARG"
            ;;
        c)
            echo "Found the -c option"
            ;;
        d)
            echo "Found the -d option"
            ;;
        *)
            echo "Unknown option: $opt"
            ;;
    esac
done

# 处理剩余的其他参数
shift $[ $OPTIND - 1 ]
count=1
for param in "$@"
do
    echo "Parameter #$count: $param"
    count=$[ $count + 1 ]
done

# 运行结果输出
# [libing@bd-3 shells]$ ./use_getopts.sh -a -b "test1 test2" -f -d test3 test4
# Found the -a option
# Found the -b option, with value test1 test2
# Unknown option: ?
# Found the -d option
# Parameter #1: test3
# Parameter #2: test4