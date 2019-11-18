#!/bin/sh
# JAN の商品コード JSON データを /JAN にクローンします。
# GitHub のプライベートリポジトリであるため、事前に ~/.ssh に以下を
# 設置しておいてください。
#   - id_rsa （秘密鍵）
#   - id_rsa.pub （公開鍵）

which jq || {
    sudo apt install jq -y
}

ssh -T git@github.com && \
sudo mkdir /JAN && \
sudo chmod 0777 /JAN && \
git clone git@github.com:KEINOS/JAN_INFO.git /JAN
