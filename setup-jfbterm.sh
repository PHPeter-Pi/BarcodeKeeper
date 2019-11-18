#!/bin/bash
# =============================================================================
#  LCD ディスプレイのターミナル画面に日本語フォントを表示するための設定スクリプト
# =============================================================================
# このスクリプトは直接ラズパイ Zero 上で実行します。なお、事前に以下を行っておいてください。
#   1. LCD ディスプレイのドライバインストール
#   2. 起動したら LCD ディスプレイにターミナルが表示されていることを確認
#   3. Locale の設定で日本語（ja_JP.UTF-8 UTF-8）とタイムゾーン（Tokyo）を設定済み。
# -----------------------------------------------------------------------------
# Raspbian Lite、つまり CUI で動かすことを前提としているため、標準の状態では LCD ディスプ
# レイ上のターミナル（tty1）には日本語フォントを表示できません。（GUI 上のターミナルには可能）
# jfbterm （ tty 1 のフレームバッファを書き換えるて描画するコマンド）を使って日本語フォント
# を表示させます。

# 日本語フォントのインストール
sudo apt install \
    ttf-kochi-gothic \
    xfonts-intl-japanese \
    xfonts-intl-japanese-big \
    xfonts-kaname \
    jfbterm