# keepassxc
# See install.sh for how to run this container image

ARG VERSION="2.7.1"
ARG REVISION="5916a8f8dd93eb6a5de544caedd7a9d8e9a3b1ee"

FROM alpine:latest as builder

ARG VERSION
ARG REVISION

RUN set -x && \
    apk upgrade && \
    apk --no-cache add --virtual .build-dependencies \
        argon2-dev \
        asciidoctor \
        automake \
        bash \
        cmake \
        curl-dev \
        expat \
        g++ \
        gcc \
        git \
        libgcrypt-dev \
        libmicrohttpd-dev \
        libqrencode-dev \
        libsodium-dev \
        make \
        qt5-qtbase-dev \
        qt5-qtsvg-dev \
        qt5-qttools-dev \
        qt5-qtx11extras-dev \
        zlib-dev && \
    git clone --branch ${VERSION} https://github.com/keepassxreboot/keepassxc.git /usr/src/keepassxc && \
    cd /usr/src/keepassxc && \
    git reset --hard ${REVISION} && \
    mkdir build && \
    cd build && \
    cmake \
        -DCMAKE_BUILD_TYPE=Release \
        -DKEEPASSXC_BUILD_TYPE=Release \
        -DWITH_TESTS=OFF \
        -DWITH_XC_AUTOTYPE=ON \
        -DWITH_XC_KEESHARE=OFF \
        -DWITH_XC_YUBIKEY=OFF \
        .. && \
    make && \
    make install && \
    echo "keepassxc build complete"

FROM alpine:latest

ARG VERSION
ARG REVISION
ENV KEEPASSXC_VERSION="${VERSION}" \
    KEEPASSXC_REVISION="${REVISION}"

COPY --from=builder /usr/local/bin/keepassxc /usr/local/bin/keepassxc
COPY --from=builder /usr/local/share/keepassxc/ /usr/local/share/keepassxc/

RUN set -x && \
    apk upgrade && \
    apk --no-cache add \
        argon2-libs \
        libcurl \
        libgcrypt \
        libmicrohttpd \
        libqrencode \
        libsodium \
        mesa-dri-intel \
        qt5-qtbase \
        qt5-qtbase-x11 \
        qt5-qtsvg \
        qt5-qttools \
        ttf-dejavu \
        zlib && \
    rm -rf /var/cache/* && \
    addgroup keepassxc && \
    adduser -G keepassxc -s /bin/sh -D keepassxc

USER keepassxc

ENTRYPOINT [ "/usr/local/bin/keepassxc" ]

LABEL org.opencontainers.image.title="keepassxc" \
    org.opencontainers.image.description="keepassxc in Docker" \
    org.opencontainers.image.revision="${REVISION}" \
    org.opencontainers.image.version="${VERSION}"

