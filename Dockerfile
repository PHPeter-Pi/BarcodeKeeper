FROM keinos/alpine

COPY ./input_barcode.sh /usr/local/bin/input_barcode

ENTRYPOINT [ "input_barcode" ]