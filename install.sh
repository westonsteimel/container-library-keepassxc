#!/usr/bin/env bash

# Provide a wrapper script and desktop icon for using the keepassxc container

# Parameters to control the tags, versions and streams to be built
IMG_TAG="westonsteimel/keepassxc:latest"
GIT_REF="master"
RELEASE="stable"

# Set these to where you normally keep your stuff
KEEPASSXC_CONFIG="${HOME}/.config/keepassxc"
KEEPASSXC_DATABASES="${HOME}/kdbx"
KEEPASSXC_DESKTOP="${HOME}/Desktop/keepassxc.desktop"
KEEPASSXC_HELPER="${HOME}/bin/keepassxc.sh"

# Make sure the config location is present and owned by your user
if [ ! -d "$(dirname ${KEEPASSXC_CONFIG})" ]; then
    mkdir -p "$(dirname ${KEEPASSXC_CONFIG})"
fi

# Make sure the helper script location actually exists
if [ ! -d "$(dirname ${KEEPASSXC_HELPER})" ]; then
    mkdir -p "$(dirname ${KEEPASSXC_HELPER})"
fi

# Build the container image
docker build \
    --build-arg "GIT_REF=${GIT_REF}" \
    --file "${RELEASE}/Dockerfile" \
    --tag "${IMG_TAG}" \
    .

# Prepare the helper wrapper script for running this container image
HELPER="docker run \
    --detach \
    --env "DISPLAY=unix${DISPLAY}" \
    --volume "${KEEPASSXC_CONFIG}:/home/keepassxc/.config/keepassxc" \
    --volume "${KEEPASSXC_DATABASES}:/home/keepassxc/kdbx" \
    --volume /etc/machine-id:/etc/machine-id:ro \
    --volume /tmp/.X11-unix:/tmp/.X11-unix \
    --volume /usr/share/X11/xkb:/usr/share/X11/xkb/:ro \
    ${IMG_TAG}"
echo "${HELPER}" > "${KEEPASSXC_HELPER}"
chmod +x "${KEEPASSXC_HELPER}"

# Prepare a helpful (GNOME) desktop icon for launching this application
DESKTOP="[Desktop Entry]
Comment=
Exec=${KEEPASSXC_HELPER}
Icon=preferences-system-privacy
Name=keepassxc
Terminal=false
Type=Application"
echo "${DESKTOP}" > "${KEEPASSXC_DESKTOP}"
chmod +x "${KEEPASSXC_DESKTOP}"
