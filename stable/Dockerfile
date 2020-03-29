# keepassxc
# See install.sh for how to run this container image

ARG KEEPASSXC_VERSION="2.5.4"
FROM alpine:edge as builder

ARG KEEPASSXC_VERSION
ENV KEEPASSXC_VERSION "${KEEPASSXC_VERSION}"

RUN set -x && \
    apk upgrade && \
    apk --no-cache add --virtual .build-dependencies \
        argon2-dev \
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
    git clone --depth 1 --branch ${KEEPASSXC_VERSION} https://github.com/keepassxreboot/keepassxc.git /usr/src/keepassxc && \
    cd /usr/src/keepassxc && \
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

RUN git clone --depth 1 https://github.com/tylert/diceware-wordlists/ /diceware-wordlists

FROM alpine:edge

ARG KEEPASSXC_VERSION

COPY --from=builder /usr/local/bin/keepassxc /usr/local/bin/keepassxc
COPY --from=builder /usr/local/share/keepassxc/ /usr/local/share/keepassxc/
COPY --from=builder /diceware-wordlists/*.wordlist /usr/local/share/keepassxc/wordlists/

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
    org.opencontainers.image.url="https://github.com/westonsteimel/docker-keepassxc" \ 
    org.opencontainers.image.source="https://github.com/westonsteimel/docker-keepassxc" \
    org.opencontainers.image.version="${KEEPASSXC_VERSION}" \
    version="${KEEPASSXC_VERSION}"
