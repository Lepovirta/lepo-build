FROM debian:stable-slim

ENV HUGO_VERSION 0.54.0

COPY download_hugo.sh download_hugo.sh

RUN set -e && \
    apt-get update && \
    apt-get install -y python3-pip git curl libdigest-sha-perl && \
    pip3 install awscli && \
    ./download_hugo.sh && \
    mv hugo /usr/local/bin/hugo && \
    rm -rf /var/lib/apt/lists/* && \
    rm download_hugo.sh

