#!/bin/bash

ANDROID_ZIPALIGN="/home/pinkasey/androidSDK/build-tools/28.0.0/zipalign"
ANDROID_KEY_PATH="/home/pinkasey/.keystore/activegan-release-key.keystore"
ANDROID_KEY_ALIAS="activegan-release-key"


jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore ${ANDROID_KEY_PATH} platforms/android/build/outputs/apk/android-release-unsigned.apk ${ANDROID_KEY_ALIAS}
jarsigner -verify -certs platforms/android/build/outputs/apk/android-release-unsigned.apk
${ANDROID_ZIPALIGN} -vf 4 platforms/android/build/outputs/apk/android-release-unsigned.apk ./build/wphc-android.apk

#jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore ${ANDROID_KEY_PATH} platforms/android/build/outputs/apk/android-armv7-release-unsigned.apk ${ANDROID_KEY_ALIAS}
#jarsigner -verify -certs platforms/android/build/outputs/apk/android-armv7-release-unsigned.apk
#${ANDROID_ZIPALIGN} -vf 4 platforms/android/build/outputs/apk/android-armv7-release-unsigned.apk ./build/wphc-android-armv7.apk
