# The global build args need to all be prefixed with ARG for the update substitutions to work
ARG KEEPASSXC_REPOSITORY="https://github.com/keepassxreboot/keepassxc"
ARG KEEPASSXC_VERSION="2.7.10"
ARG KEEPASSXC_BRANCH="2.7.10"
ARG KEEPASSXC_COMMIT="b342be457153aa098c8bbce0f8b0fd3baa8c158f"

FROM alpine:latest AS builder

ARG KEEPASSXC_REPOSITORY \
    KEEPASSXC_BRANCH \
    KEEPASSXC_COMMIT

RUN set -x && \
    apk upgrade && \
    apk --no-cache add --virtual .build-dependencies \
    argon2-dev \
    argon2-static \
	asciidoctor \
	botan3-dev \
	build-base \
    cmake \
    keyutils-dev \
	libqrencode-dev \
	libusb-dev \
    libxi-dev \
	libxi-static \
    libxtst-dev \
	libxtst-static \
    minizip-dev \
    minizip-static \
    pcsc-lite-dev \
	pcsc-lite-static \
	qt5-qtbase-dev \
	qt5-qtsvg-dev \
	qt5-qttools-dev \
	qt5-qtx11extras-dev \
    readline-dev \
	readline-static \
	samurai \
    zlib-dev \
	zlib-static \
    git && \
    git clone --branch ${KEEPASSXC_BRANCH} ${KEEPASSXC_REPOSITORY} /usr/src/keepassxc && \
    cd /usr/src/keepassxc && \
    git reset --hard ${KEEPASSXC_COMMIT} && \
    mkdir build && \
    cd build && \
    export CXXFLAGS="$CXXFLAGS -flto=auto" && \
    export LDFLAGS="-static" && \
	cmake -G Ninja -B build \
		-DCMAKE_INSTALL_PREFIX=/usr/local \
		-DCMAKE_INSTALL_LIBDIR=/usr/local/lib \
		-DCMAKE_BUILD_TYPE=MinSizeRel \
		-DKEEPASSXC_BUILD_TYPE=Release \
		-DWITH_XC_AUTOTYPE=ON \
		-DWITH_XC_NETWORKING=ON \
		-DWITH_XC_BROWSER=ON \
		-DWITH_XC_BROWSER_PASSKEYS=ON \
		-DWITH_XC_YUBIKEY=ON \
		-DWITH_XC_SSHAGENT=ON \
		-DWITH_XC_KEESHARE=ON \
		-DWITH_XC_UPDATECHECK=OFF \
		-DWITH_XC_FDOSECRETS=ON \
		-DWITH_GUI_TESTS=ON \
        .. && \
    cmake --build build && \
    cmake --install build && \
    echo "keepassxc build complete"

FROM alpine:latest

ARG KEEPASSXC_REPOSITORY \
    KEEPASSXC_VERSION \
    KEEPASSXC_BRANCH \
    KEEPASSXC_COMMIT

ENV KEEPASSXC_REPOSITORY="${KEEPASSXC_REPOSITORY}" \
    KEEPASSXC_VERSION="${KEEPASSXC_VERSION}" \
    KEEPASSXC_BRANCH="${KEEPASSXC_BRANCH}" \
    KEEPASSXC_COMMIT="${KEEPASSXC_COMMIT}"

COPY --from=builder /usr/local/bin/keepassxc* /usr/local/bin/
COPY --from=builder /usr/local/lib/keepassxc/ /usr/local/lib/keepassxc/
COPY --from=builder /usr/local/share/keepassxc/ /usr/local/share/keepassxc/

RUN set -x && \
    apk upgrade && \
    apk --no-cache add \
        keyutils-libs \
        libqrencode \
        botan3-libs \
        libusb \
        qt5-qtbase \
        qt5-qtbase-x11 \
        qt5-qtsvg \
        qt5-qttools \
        qt5-qtx11extras \
        ttf-dejavu && \
    rm -rf /var/cache/* && \
    addgroup keepassxc && \
    adduser -G keepassxc -s /bin/sh -D keepassxc

USER keepassxc

ENTRYPOINT [ "/usr/local/bin/keepassxc" ]

LABEL org.opencontainers.image.title="keepassxc" \
    org.opencontainers.image.description="keepassxc in Docker" \
    org.opencontainers.image.revision="${KEEPASSXC_COMMIT}" \
    org.opencontainers.image.version="${KEEPASSXC_VERSION}"

