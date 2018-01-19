#!/bin/bash

# 一个冒号表示参数后必须跟随参数值,两个冒号表示参数后的参数值是可选的
CMD_OPTIONS=$(getopt -n "$0" -o ab:c:: --long along,blong:,clong:: -- "$@")

# 如果上面命令运行出错,就退出
if [ $? != 0 ]; then
    echo "Options are error..."
    exit 1
fi

echo $CMD_OPTIONS

# 根据$CMD_OPTIONS的内容,重设位置参数$1, $2, ... 的值
eval set -- $CMD_OPTIONS

while true
do
    case "$1" in
        -a|--along)
            echo "Option a"
            shift
            ;;
        -b|--blong)
            echo "Option b, with argument $2"
            shift 2
            ;;
        -c|--clong)
            case "$2" in
                "")
                    echo "Option c, no argument"
                    shift 2
                    ;;
                *)
                    echo "Option c, with argument $2"
                    shift 2
                    ;;
            esac
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Internal error!"
            exit 1
            ;;
    esac
done

# 处理剩余的其他参数
for arg in $@
do
    echo "Processing $arg"
done

# 运行结果输出
# [libing@bd-3 shells]$ ./use_getopt.sh -b 123 -a -c file1 file2
# -b '123' -a -c '' -- 'file1' 'file2'
# Option b, with argument 123
# Option a
# Option c, no argument
# Processing file1
# Processing file2
# [libing@bd-3 shells]$ ./use_getopt.sh -b 123 -a -c456 file1 file2
# -b '123' -a -c '456' -- 'file1' 'file2'
# Option b, with argument 123
# Option a
# Option c, with argument 456
# Processing file1
# Processing file2