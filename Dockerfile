FROM alpine

# Setup tools used during Lepo build process
RUN set -e && \
    apk --update add python3 curl git perl-utils bash && \
    python3 -m ensurepip && \
    pip3 install --upgrade pip setuptools && \
    pip3 install awscli && \
    rm -r /root/.cache && \
    rm -rf /var/cache/apk/*

# Hugo variables
ENV HUGO_VERSION="0.54.0" ARCH="64bit"
ENV RELEASE_BASE_URL="https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}" \
    RELEASE_FILENAME="hugo_${HUGO_VERSION}_Linux-${ARCH}.tar.gz"
ENV CHECKSUMS_URL="${RELEASE_BASE_URL}/hugo_${HUGO_VERSION}_checksums.txt" \
    RELEASE_URL="${RELEASE_BASE_URL}/${RELEASE_FILENAME}"

# Download and install Hugo
RUN set -e && \
    curl -fL --retry 3 --retry-connrefused --retry-delay 2 -o "${RELEASE_FILENAME}" "${RELEASE_URL}" && \
    curl -sfSL --retry 3 --retry-connrefused --retry-delay 2 "${CHECKSUMS_URL}" | grep "${RELEASE_FILENAME}" | shasum -c && \
    tar xvfz "${RELEASE_FILENAME}" hugo && \
    mv hugo /usr/local/bin/hugo && \
    hugo version && \
    rm "${RELEASE_FILENAME}"

# Non-root user
WORKDIR /project
RUN set -e && \
    addgroup -g 10101 -S builder && \
    adduser -u 10101 -S -G builder builder && \
    chown -R builder:builder /project
USER builder:builder
