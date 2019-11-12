#!/bin/sh

docker-compose --file docker-compose.arm32v6.yml \
  up && \
docker-compose --file docker-compose.arm32v6.yml \
  run \
  -v ./data:/data \
  --entrypoint input_barcode \
  barcodekeeper
