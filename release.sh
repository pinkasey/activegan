#!/bin/sh

set -e

ANDROID_ZIPALIGN="/Applications/android-sdk-macosx/build-tools/23.0.3/zipalign"
ANDROID_KEY_PATH="activegan-release-key.keystore"
ANDROID_KEY_ALIAS="activegan-release-key"

read -p "Release major, minor or patch? " version
version=${version:-""}

read -p "Which platforms do you want to build? (android ios): " platforms
platforms=${platforms:-"android ios"}

# updgrade version before release
npm run increaseVersion -- -s ${version}

# package the app
npm run dumpprod

if [[ " ${platforms[*]} " == *" android "* ]]; then
    npm run buildProdAndroid

#    jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore ${ANDROID_KEY_PATH} platforms/android/build/outputs/apk/android-release-unsigned.apk ${ANDROID_KEY_ALIAS}
#    jarsigner -verify -certs platforms/android/build/outputs/apk/android-release-unsigned.apk
#    ${ANDROID_ZIPALIGN} -vf 4 platforms/android/build/outputs/apk/android-release-unsigned.apk ./build/wphc-android.apk
#
#    #i want to disable the next 6 lines but i don't want to comment them out. for some reason, i only get one apk - android-release-unsigned.apk
#    if [[ " ${platforms[*]} " == *" sdfsdfdsf "* ]]; then
#
    jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore ${ANDROID_KEY_PATH} platforms/android/build/outputs/apk/android-x86-release-unsigned.apk ${ANDROID_KEY_ALIAS}
    jarsigner -verify -certs platforms/android/build/outputs/apk/android-x86-release-unsigned.apk
    ${ANDROID_ZIPALIGN} -vf 4 platforms/android/build/outputs/apk/android-x86-release-unsigned.apk ./build/wphc-android-x86.apk

    jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore ${ANDROID_KEY_PATH} platforms/android/build/outputs/apk/android-armv7-release-unsigned.apk ${ANDROID_KEY_ALIAS}
    jarsigner -verify -certs platforms/android/build/outputs/apk/android-armv7-release-unsigned.apk
    ${ANDROID_ZIPALIGN} -vf 4 platforms/android/build/outputs/apk/android-armv7-release-unsigned.apk ./build/wphc-android-armv7.apk
#
#    fi
fi

if [[ " ${platforms[*]} " == *" ios "* ]]; then
    npm run buildProdIOS

    rm -rf ./build/ios.app
    mv ./platforms/ios/build/device/*.app ./build/ios.app
    xcrun -sdk iphoneos PackageApplication -v $PWD/build/ios.app
    sigh resign ./build/ios.ipa
fi
