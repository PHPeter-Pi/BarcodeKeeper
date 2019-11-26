#!/bin/bash

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
NAME_FILE_DATA_OK="barcode_${ID_DATE:-offline}_OK.csv"
NAME_FILE_DATA_NG="barcode_${ID_DATE:-offline}_NG.csv"
PATH_DIR_DATA="/data"
PATH_FILE_DATA_OK="${PATH_DIR_DATA}/${NAME_FILE_DATA_OK}"
PATH_FILE_DATA_NG="${PATH_DIR_DATA}/${NAME_FILE_DATA_NG}"

# 処理を停止する読み取りコード
CODE_STOP="${CODE_STOP:-none}"

# 罫線描画用のデフォルト値
CHAR_HR_DEFAULT='-'
SCREEN_WIDTH_DEFAULT=20

# 起動音
beep ready

# -----------------------------------------------------------------------------
#  関数
# -----------------------------------------------------------------------------

echo_hr(){
  printf -v _hr "%*s" ${SCREEN_WIDTH} && echo ${_hr// /${1-$CHAR_HR_DEFAULT}}
}

getNameProduct () {
    name_product=''
    code_jan=$1
    path_file_jan_info="/JAN/${code_jan}.json"
    [ -s $path_file_jan_info ] || {
        return 1
    }

    cat $path_file_jan_info | jq -r '[.[].Product.productName] | unique' || {
        return 1
    }
    return 0
}

isStopCode () {
    [ "${CODE_STOP}" = "${1}" ]
    return $?
}

# -----------------------------------------------------------------------------
#  本体スクリプト
# -----------------------------------------------------------------------------

clear

if [ -n "${TERM}" ];
  then SCREEN_WIDTH=$(tput cols);
  else SCREEN_WIDTH=$SCREEN_WIDTH_DEFAULT;
fi

echo_hr =
echo ' バーコードレコーダー'
echo_hr =

if [ "${CODE_STOP}" = "none" ]; then
    echo '- ストップ・コードの入力:'
    echo '  処理を終了する際に使うバーコードを読み込んでくだ'
    echo '  さい。このコードが読み込まれると処理を終了します。'
    echo -n '  STOP Code:'; beep pi; read input_code
    CODE_STOP=$input_code && echo '- ストップ・コードは:' $CODE_STOP
fi

while :
do
    echo_hr

    echo -n 'JAN Code:'; beep pi; read input_code

    isStopCode $input_code && {
        echo 'ストップ・コードを検知しました。プログラムを終了します ...'
        beep shutdown
        exit 0
    }

    [ -n "${input_code}" ] && {
        ID_TIME=$(date +'%H%M%S')
        ID_MILI=$(($(date +%s%N)/1000000))

        getNameProduct $input_code || {
            echo "\"${ID_TIME}\",\"${ID_MILI}\",\"${input_code}\"" >> $PATH_FILE_DATA_NG || {
                echo '保存に失敗しました。再読み込みしてください。'
                beep ng
                continue
            }
            echo '商品情報がありません:' $input_code
            echo '  登録番号:' $( echo $ID_TIME | sed -r ':a;s/\B[0-9]{3}\>/-&/g;ta' )
            beep ng
            continue
        }
        # バーコードの読み取り値の保存
        echo "\"${ID_TIME}\",\"${ID_MILI}\",\"${input_code}\"" >> $PATH_FILE_DATA_OK || {
            echo '保存に失敗しました。再読み込みしてください。'
            beep ng
            continue
        }
        echo '  登録番号:' $( echo $ID_TIME | sed -r ':a;s/\B[0-9]{3}\>/-&/g;ta' )
        beep ok
    }

done
