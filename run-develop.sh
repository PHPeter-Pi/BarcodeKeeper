#!/bin/bash

NAME_IMAGE_DOCKER='barcode_keeper:local'

docker build -t $NAME_IMAGE_DOCKER . && \
docker run \
    --rm \
    -it \
    --env-file $(pwd)/ENVFILE.env \
    -v $(pwd)/input_barcode.sh:/usr/local/bin/input_barcode \
    -v $(pwd)/data/:/data \
    $NAME_IMAGE_DOCKER \
    input_barcode
