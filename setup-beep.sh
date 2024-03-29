#!/bin/sh
# =============================================================================
#  GPIO につなげたブザーから音を出すための設定スクリプト
# =============================================================================
#  Beep_GPIO のリポジトリをクローンして、シンボリックリンクを張ります。GPIO へのアクセスに
#  Python3 および pip3 の rpi.gpio を利用しています。コンテナで利用する場合は注意

cd ~ && \
git clone https://github.com/PHPeter-Pi/Beep_GPIO.git && \
ln -s ~/Beep_GPIO/beep.sh /usr/local/bin/beep
