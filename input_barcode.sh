#!/bin/sh

echo '==================='
echo ' Barcode Recorder'
echo '==================='

# -----------------------------------------------------------------------------
#  初期設定
# -----------------------------------------------------------------------------
# シンボリック・リンク経由での利用のための絶対パス
PATH_FILE_SCRIPT=$(readlink $0)
PATH_DIR_CURR=$(cd $(dirname ${PATH_FILE_SCRIPT:-$0}); pwd)

# 保存先のパス指定
NAME_FILE_DATA="barcode_${ID_DATE}.csv"
PATH_DIR_DATA="/data"
PATH_FILE_DATA="${PATH_DIR_DATA}/${NAME_FILE_DATA}"

# ファイル名に使われる ID
ID_DATE=$(date +'%Y%m%d')

# 処理を停止する読み取りコード
CODE_STOP="${CODE_STOP:-STOP}"
echo '- STOP CODE is:' $CODE_STOP

# -----------------------------------------------------------------------------
#  関数
# -----------------------------------------------------------------------------

isStopCode () {
    [ "${CODE_STOP}" = "${1}" ]
    return $?
}

# -----------------------------------------------------------------------------
#  本体スクリプト
# -----------------------------------------------------------------------------
while :
do
    read -p 'JAN Code: ' input_code
    isStopCode $input_code && {
        echo 'Stop code detected. Exiting program ...'
        exit 0
    }

    [ -n "${input_code}" ] && {
        ID_TIME=$(date +'%H%M%S')
        ID_MILI=$(($(date +%s%N)/1000000))
        echo "\"${ID_TIME}\",\"${ID_MILI}\",\"${input_code}\"" >> $PATH_FILE_DATA || {
            beep ng
            continue
        }
        beep ok
    }

done
