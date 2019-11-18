FROM arm32v6/alpine

USER root
COPY ./input_barcode.sh /usr/local/bin/input_barcode
COPY ./setup-beep.sh /setup-beep.sh
RUN apk --no-cache add \
        bash \
        git \
        python3 \
        python3-dev \
        musl-dev \
        gcc && \
    cd ~ && \
    pip3 install --upgrade pip && \
    pip3 install rpi.gpio && \
    /setup-beep.sh

ENTRYPOINT [ "input_barcode" ]
