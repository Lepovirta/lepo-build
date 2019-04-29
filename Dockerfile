FROM alpine

# Setup tools used during Lepo build process
RUN set -e && \
    apk --update add npm curl git perl-utils bash && \
    npm install -g netlify-cli && \
    rm -rf /var/cache/apk/*

# Hugo variables
ENV HUGO_VERSION="0.54.0" HUGO_ARCH="64bit"
ENV HUGO_RELEASE_BASE_URL="https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}" \
    HUGO_RELEASE_FILENAME="hugo_${HUGO_VERSION}_Linux-${HUGO_ARCH}.tar.gz"
ENV HUGO_CHECKSUMS_URL="${HUGO_RELEASE_BASE_URL}/hugo_${HUGO_VERSION}_checksums.txt" \
    HUGO_RELEASE_URL="${HUGO_RELEASE_BASE_URL}/${HUGO_RELEASE_FILENAME}"

# Download and install Hugo
RUN set -e && \
    curl -fL --retry 3 --retry-connrefused --retry-delay 2 -o "${HUGO_RELEASE_FILENAME}" "${HUGO_RELEASE_URL}" && \
    curl -sfSL --retry 3 --retry-connrefused --retry-delay 2 "${HUGO_CHECKSUMS_URL}" | grep "${HUGO_RELEASE_FILENAME}" | shasum -c && \
    tar xvfz "${HUGO_RELEASE_FILENAME}" hugo && \
    mv hugo /usr/local/bin/hugo && \
    hugo version && \
    rm "${HUGO_RELEASE_FILENAME}"

# Lukki variables
ENV LUKKI_VERSION="0.1.2" LUKKI_ARCH="x86_64"
ENV LUKKI_RELEASE_BASE_URL="https://github.com/Lepovirta/lukki/releases/download/v${LUKKI_VERSION}/" \
    LUKKI_RELEASE_FILENAME="lukki_${LUKKI_VERSION}_Linux_${LUKKI_ARCH}.tar.gz"
ENV LUKKI_CHECKSUMS_URL="${LUKKI_RELEASE_BASE_URL}/checksums.txt" \
    LUKKI_RELEASE_URL="${LUKKI_RELEASE_BASE_URL}/${LUKKI_RELEASE_FILENAME}"

# Download and install lukki
RUN set -e && \
    curl -fL --retry 3 --retry-connrefused --retry-delay 2 -o "${LUKKI_RELEASE_FILENAME}" "${LUKKI_RELEASE_URL}" && \
    curl -sfSL --retry 3 --retry-connrefused --retry-delay 2 "${LUKKI_CHECKSUMS_URL}" | grep "${LUKKI_RELEASE_FILENAME}" | shasum -c && \
    tar xvfz "${LUKKI_RELEASE_FILENAME}" lukki && \
    mv lukki /usr/local/bin/lukki && \
    lukki -version && \
    rm "${LUKKI_RELEASE_FILENAME}"

# Install Github commenter
COPY gh-comment.sh /usr/local/bin/gh-comment

# Non-root user
WORKDIR /project
RUN set -e && \
    addgroup -g 10101 -S builder && \
    adduser -u 10101 -S -G builder builder && \
    chown -R builder:builder /project
USER builder:builder
