#!/bin/sh
# This shell script simply copies the built plug-in to "~/Library/Graphics/Quartz Composer Plug-Ins" and overrides any previous version at that location

mkdir -p "$USER_LIBRARY_DIR/Graphics/Quartz Composer Plug-Ins"
rm -rf "$USER_LIBRARY_DIR/Graphics/Quartz Composer Plug-Ins/QCbacklight.plugin"
cp -rf "$BUILT_PRODUCTS_DIR/QCbacklight.plugin" "$USER_LIBRARY_DIR/Graphics/Quartz Composer Plug-Ins/"

