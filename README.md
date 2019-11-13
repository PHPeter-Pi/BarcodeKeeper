# Barcode Keeper

棚卸し支援のコンテナです。標準入力から受け取った値をファイルに追記で保存するだけです。

## 主な利用方法

ラズパイ Zero にモバイルバッテリーと USB バーコード・リーダーを繋げて、商品のバーコードを記録するのに利用します。

## 必須設定（ラズパイ側）

- あらかじめ以下をインストールしておいてください。
  - `Docker` `docker-compose` `git` （オプション `vim` `curl`）
- スピーカーを GPIO につなげておいてください。
  - このコンテナは、データが保存されると Beep 音を鳴らします。ラズパイ Zero の GPIO にピエゾ・スピーカーをつなげる必要があります。
  - 配線に関する詳細: https://github.com/PHPeter-Pi/Beep_GPIO

## 基本動作

```shellsession
$ # Barcode Keeper の clone
$ git clone https://github.com/PHPeter-Pi/BarcodeKeeper.git
$ cd BarcodeKeeper
$ # 環境変数ファイルを編集（STOP コードを任意のものに変更する）
$ cp ENVFILE.env.sample ENVFILE.env
$ vi ENVFILE.env
...
$ ./run-arm32v6.sh
```

1. コンテナが起動すると、標準入力で入力待ちになります。
2. 入力 + Enter で入力値がファイルに追記されていきます。
3. 入力値が `ENVFILE.env` に記載されている `CODE_STOP` と同じ値の場合は処理を中止します。

## 仕様

- 読み込んだデータは、コンテナの `/data` ディレクトリに保存されていきます。
- 正常に読み込むと `beep ok` が実行され、失敗すると `beep ng` が実行されます。
- 保存ファイルは日付ごとに作成されます。（`barcode_YYYYMMDD.csv`）
- 保存データは 3 列の CSV 形式です。列の書式は以下の通り:
  - `"読み込み時間　HHMMDD"`,`"<ミリ秒>"`,`"読み込みデータ"`
