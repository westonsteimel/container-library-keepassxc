#!/usr/bin/env bash

# Provide a nice wrapper for using the keepassxc docker container

# Set these to where you normally keep your stuff
if [ -z "${IMG_TAG}" ]; then
    IMG_TAG='westonsteimel/keepassxc:latest'
fi
if [ -z "${KEEPASSXC_CONFIG}" ]; then
    KEEPASSXC_CONFIG="${HOME}/.config/keepassxc"
fi
if [ -z "${KEEPASSXC_DATABASES}" ]; then
    KEEPASSXC_DATABASES="${HOME}/data"
fi
if [ -z "${KEEPASSXC_DESKTOP}" ]; then
    KEEPASSXC_DESKTOP="${HOME}/Desktop/keepassxc.desktop"
fi
if [ -z "${KEEPASSXC_HELPER}" ]; then
    KEEPASSXC_HELPER="${HOME}/bin/keepassxc.sh"
fi
if [ -z "${KEEPASSXC_VERSION}" ]; then
    KEEPASSXC_VERSION='2.5.4'
fi
if [ -z "${KEEPASSXC_VARIANT}" ]; then
    KEEPASSXC_VARIANT='stable'
fi

# Make sure the config location is present and owned by your user
# Use the short option version here so it works on both Linux and macOS
if [ ! -d "${KEEPASSXC_CONFIG}" ]; then
    mkdir -p "${KEEPASSXC_CONFIG}"
fi

# Build the container image
docker build \
    --build-arg "KEEPASSXC_VERSION=${KEEPASSXC_VERSION}" \
    --file "${KEEPASSXC_VARIANT}/Dockerfile" \
    --tag "${IMG_TAG}" \
    .

# Prepare the helper wrapper script for running this container image
cat << EOF > "${KEEPASSXC_HELPER}"
docker run \
    --detach \
    --env "DISPLAY=unix${DISPLAY}" \
    --volume "${KEEPASSXC_CONFIG}:/home/keepassxc/.config/keepassxc" \
    --volume "${KEEPASSXC_DATABASES}:/home/keepassxc/kdbx" \
    --volume /etc/machine-id:/etc/machine-id:ro \
    --volume /tmp/.X11-unix:/tmp/.X11-unix \
    --volume /usr/share/X11/xkb:/usr/share/X11/xkb/:ro \
    "${IMG_TAG}"
EOF
# --volume /tmp:/usr/local/share/keepassxc/wordlists:ro \
chmod +x "${KEEPASSXC_HELPER}"

# Prepare a helpful (GNOME) desktop icon for launching this application
cat << EOF > "${KEEPASSXC_DESKTOP}"
[Desktop Entry]
Comment=
Exec=${KEEPASSXC_HELPER}
Icon=preferences-system-privacy
Name=keepassxc
Terminal=false
Type=Application
EOF
chmod +x "${KEEPASSXC_DESKTOP}"
