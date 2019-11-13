FROM arm32v6/alpine

COPY ./input_barcode.sh /usr/local/bin/input_barcode

RUN apk --no-cache add \
        git \
        python3 \
        python3-dev \
        musl-dev \
        gcc && \
    cd ~ && \
    pip3 install --upgrade pip && \
    pip3 install rpi.gpio && \
    git clone https://github.com/PHPeter-Pi/Beep_GPIO.git && \
    ln -s ~/Beep_GPIO/beep.sh /usr/local/bin/beep

ENTRYPOINT [ "input_barcode" ]
