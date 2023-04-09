FROM python:3.11-alpine
WORKDIR /app

RUN apk add --update gcc libc-dev linux-headers libusb-dev cargo tiff-dev \
    jpeg-dev openjpeg-dev zlib-dev freetype-dev lcms2-dev \
    libwebp-dev tcl-dev tk-dev harfbuzz-dev fribidi-dev libimagequant-dev \
    libxcb-dev libpng-dev
RUN apk add --update ffmpeg netcat-openbsd git

COPY . .
RUN pip install .

COPY ./docker/entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
CMD ["unifi-cam-proxy"]
