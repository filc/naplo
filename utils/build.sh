#!/bin/sh

echo Building APK...
flutter build apk

cp build/app/outputs/apk/release/app-release.apk ~/Desktop/
echo Copied APK to Desktop

echo Done.