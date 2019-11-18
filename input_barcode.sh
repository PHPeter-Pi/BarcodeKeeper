#!/bin/bash

clear

echo '======================'
echo ' バーコードレコーダー'
echo '======================'

# -----------------------------------------------------------------------------
#  初期設定
# -----------------------------------------------------------------------------
# シンボリック・リンク経由での利用のための絶対パス
PATH_FILE_SCRIPT=$(readlink $0)
PATH_DIR_CURR=$(cd $(dirname ${PATH_FILE_SCRIPT:-$0}); pwd)

# 環境変数ファイルの読み込み
NAME_FILE_ENV='ENVFILE.env'
PATH_FILE_ENV="${PATH_DIR_CURR}/${NAME_FILE_ENV}"
#echo 'Source path:' $PATH_FILE_ENV
export $(grep -v '^#' $PATH_FILE_ENV | xargs)

# ファイル名に使われる ID
ID_DATE=$(date +'%Y%m%d')

# 保存先のパス指定
NAME_FILE_DATA="barcode_${ID_DATE:-offline}.csv"
PATH_DIR_DATA="/data"
PATH_FILE_DATA="${PATH_DIR_DATA}/${NAME_FILE_DATA}"

# 処理を停止する読み取りコード
CODE_STOP="${CODE_STOP:-STOP}"
echo '- STOP CODE is:' $CODE_STOP

# 起動音
beep ready

# -----------------------------------------------------------------------------
#  関数
# -----------------------------------------------------------------------------

isStopCode () {
    [ "${CODE_STOP}" = "${1}" ]
    return $?
}

getNameProduct () {
    name_product=''
    code_jan=$1
    path_file_jan_info="/JAN/${code_jan}.json"
    [ -s $path_file_jan_info ] || {
        return 1
    }

    cat $path_file_jan_info | jq -r '.[].Product.productName | unique'
    return 0
}

# -----------------------------------------------------------------------------
#  本体スクリプト
# -----------------------------------------------------------------------------
while :
do
    read -p 'JAN Code: ' input_code

    isStopCode $input_code && {
        echo 'ストップコードを検知しました。プログラムを終了します ...'
        exit 0
    }

    [ -n "${input_code}" ] && {
        ID_TIME=$(date +'%H%M%S')
        ID_MILI=$(($(date +%s%N)/1000000))

        getNameProduct $input_code || {
            echo '商品情報がありません:' $input_code
            beep ng
            continue
        }
        # バーコードの読み取り値の保存
        echo "\"${ID_TIME}\",\"${ID_MILI}\",\"${input_code}\"" >> $PATH_FILE_DATA || {
            echo '保存に失敗しました。再読み込みしてください。'
            beep ng
            continue
        }

        beep ok
    }

done
