#!/bin/sh

#set -e

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

    ./signApk.sh
fi

if [[ " ${platforms[*]} " == *" ios "* ]]; then
    npm run buildProdIOS

    rm -rf ./build/ios.app
    mv ./platforms/ios/build/device/*.app ./build/ios.app
    xcrun -sdk iphoneos PackageApplication -v $PWD/build/ios.app
    sigh resign ./build/ios.ipa
fi
