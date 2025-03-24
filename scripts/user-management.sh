#!/bin/bash

# This is distribution destination
DIST="$AUTH_BACKEND/dist"

build_backend_auth_zip() {
    set -e

    echo "Building auth backend ZIP..."

    mkdir -p "$DIST/"
    rm -rf "$DIST"
    cd "$AUTH_BACKEND"

    echo "Updating dependencies..."
    npm ci

    echo "Compiling Typescript code to Javascript..."
    npx tsc

    echo $(git rev-parse --short=7 HEAD) \
    $([[ "$(git status --porcelain --untracked-files=no)" == "" ]] && echo "ok" || echo "tainted") \
    $USERNAME@${HOSTNAME:-$COMPUTERNAME} $(date +%s000) \
    > dist/BUILD

    cd -

    cd "$DIST" && zip -9vr "$ZIP_FILE_NAME_BACKEND" \
      lib/ ../package.json ../package-lock.json BUILD

    cd -
    set +e
}
