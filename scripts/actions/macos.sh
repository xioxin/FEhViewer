#!/bin/bash
cd ../..

rm macos/Podfile.lock

flutter build macos

mkdir dist
cp -rf build/macos/Build/Products/Release/fehviewer.app ./dist

ln -s /Applications/ ./dist/Applications

hdiutil create -fs HFS+ -srcfolder ./dist -volname "FEhViewer" "fehviewer.dmg"