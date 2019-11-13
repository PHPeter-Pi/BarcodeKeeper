#!/bin/sh
# このスクリプトはラズパイ Zero（ARM v6l）の Docker + docker-compose
# 上で、BarcodeKeeper を動かすスクリプトです。
# このスクリプトが呼び出されると、BarcodeKeeper のコンテナを起動し、標準
# 入力待ち（バーコード入力待ち）になります。
#
# ラズパイ起動時に自動起動させたい場合は、ラズパイ上で以下を行います。
# 1. このディレクトリにある input_barcode.sh のシンボリック・リンクを張ります。
#      $ ln -s $(pwd)/input_barcode.sh /usr/local/bin/input_barcode
# 2. pi ユーザーの自動ログインを設定します。
#      $ sudo raspi-config
# 3. .bashrc の行頭に以下を追加します。
#

# シンボリック・リンク経由での利用のための絶対パス
PATH_FILE_SCRIPT=$(readlink $0)
PATH_DIR_CURR=$(cd $(dirname ${PATH_FILE_SCRIPT:-$0}); pwd)

cd $PATH_DIR_CURR
git pull origin && \
docker-compose up barcodekeeper
