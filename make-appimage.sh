#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q openrct2 | awk '{print $2; exit}') # example command to get version of application here
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/icons/hicolor/scalable/apps/openrct2.svg
export DESKTOP=/usr/share/applications/io.openrct2.openrct2.desktop

# Deploy dependencies
quick-sharun /usr/bin/openrct2

# Additional changes can be done in between here

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --test ./dist/*.AppImage
