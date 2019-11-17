# Barcode Keeper

棚卸し支援のスクリプトです。標準入力から受け取った値をファイルに追記で保存するだけです。

## 主な利用方法

ラズパイ Zero にモバイルバッテリーと USB バーコード・リーダーを繋げて、商品のバーコードを記録するのに利用します。

## 本体スクリプト

- `input_barcode.sh`

## ハードウェア条件

- Raspberry Pi Zero W（3,500円程度）
- [3.5 インチ LCD RPi ディスプレイ](http://www.lcdwiki.com/MHS-3.5inch_RPi_Display)が必要です。（3,000円程度）
- ピエゾ・スピーカーを GPIO につなげておいてください。（50円程度）
  - このコンテナは、データが保存されると Beep 音を鳴らします。ラズパイ Zero の GPIO にピエゾ・スピーカーをつなげる必要があります。
  - 配線に関する詳細: https://github.com/PHPeter-Pi/Beep_GPIO
- USB 一次元バーコードリーダー（2,000円程度）

## インストール

- Locale の設定で日本語（ja_JP.UTF-8 UTF-8）とタイムゾーン（Tokyo）を設定する
    ```shellsession
    $ sudo raspi-config
    ```
- アプリのコピー
    ```shellsession
    $ # 作業ディレクトリに移動
    $ cd ~
    $ # Barcode Keeper の clone
    $ git clone https://github.com/PHPeter-Pi/BarcodeKeeper.git
    $ cd BarcodeKeeper
    $ # 環境変数ファイルを編集（STOP コードを任意のものに変更する）
    $ cp ENVFILE.env.sample ENVFILE.env
    $ vi ENVFILE.env
    ...
    $ # LCD のターミナルで日本語フォントを表示可能にする
    $ ./setup-jfbterm.sh
    $ # GPIO からのビープ音を出すライブラリをインストールする
    $ ./setup-beep.sh
    ```
- `Boot Options` で `Desktop/CLI` を `B2 Console Autologin` に設定する
    ```
    $ sudo raspi-config
    ```

- 以下を `~/.bashrc` の文頭に挿入して、ラズパイ起動時に input_barcode.sh を自動起動させて入力待ちにさせる。

    ```bash
    if [ $(tty) == '/dev/tty1' ]; then jfbterm /home/pi/BarcodeKeeper/input_barcode.sh && sudo cp -r /data/ /boot/ && beep shutdown && sudo halt; fi
    ```

## 仕様

- 読み込んだデータは、`/data` ディレクトリに保存されていきます。
- 正常に読み込むと `beep ok` が実行され、失敗すると `beep ng` が実行されます。
- 保存ファイルは日付ごとに作成されます。（`barcode_YYYYMMDD.csv`）
- 保存データは 3 列の CSV 形式です。列の書式は以下の通り:
  - `"読み込み時間　HHMMDD"`,`"<ミリ秒>"`,`"読み込みデータ"`
