#!/bin/bash

# このスクリプトは開発用です。

docker-compose \
    --file docker-compose.dev.yml \
    run \
    --entrypoint /bin/sh \
    barcodekeeper
