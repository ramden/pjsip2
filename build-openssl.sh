#!/bin/sh

OPENSSL_VERSION=$1
IOS_SDK_VERSION=$(xcodebuild -version -sdk iphoneos | grep SDKVersion | cut -f2 -d ':' | tr -d '[[:space:]]')
MIN_IOS_VERSION="13.0"

DEVELOPER=`xcode-select -print-path`

downloadOpenSSL() {
	OPENSSL_NAME=$1

	pushd . > /dev/null
	cd build
	if [ ! -d ${OPENSSL_NAME} ]; then
		curl -O "https://www.openssl.org/source/${OPENSSL_NAME}.tar.gz"
		tar -xf "${OPENSSL_NAME}.tar.gz"
	fi
	popd > /dev/null
}

buildIOS()
{
	ARCH=$1
	pushd . > /dev/null
	cd "build/${OPENSSL_VERSION}"

	if [ "$ARCH" == "x86_64" ]; then
			PLATFORM="iPhoneSimulator"
	else
			PLATFORM="iPhoneOS"
			sed -ie "s!static volatile sig_atomic_t intr_signal;!static volatile intr_signal;!" "crypto/ui/ui_openssl.c"
	fi
	echo "Start Building ${OPENSSL_VERSION} for ${PLATFORM} ${IOS_SDK_VERSION} ${ARCH}"

	export $PLATFORM
	export CROSS_TOP="${DEVELOPER}/Platforms/${PLATFORM}.platform/Developer"
	export CROSS_SDK="${PLATFORM}${IOS_SDK_VERSION}.sdk"
	export BUILD_TOOLS="${DEVELOPER}"
	export PATH="/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin:$PATH"
	echo "Configure"
	if [ "$ARCH" == "x86_64" ]; then
			export CC="${BUILD_TOOLS}/usr/bin/gcc -arch ${ARCH}"
			./Configure darwin64-x86_64-cc --openssldir="/tmp/${OPENSSL_VERSION}-iOS-${ARCH}" --prefix="/tmp/${OPENSSL_VERSION}-iOS-${ARCH}" &> "/tmp/${OPENSSL_VERSION}-iOS-${ARCH}.log"
	else
			echo "$ARCH"

			export CC=clang;
			#./Configure iphoneos-cross --openssldir="/tmp/${OPENSSL_VERSION}-iOS-${ARCH}" &> "/tmp/${OPENSSL_VERSION}-iOS-${ARCH}.log"
			./Configure ios64-cross no-shared no-dso no-hw no-engine --prefix="/tmp/${OPENSSL_VERSION}-iOS-${ARCH}" &> "/tmp/${OPENSSL_VERSION}-iOS-${ARCH}.log"
			export CFLAGS="${CFLAGS} -isysroot ${CROSS_TOP}/SDKs/${CROSS_SDK}"
	fi
	# add -isysroot to CC=
	#sed -ie "s!^CFLAG=!CFLAG=-isysroot ${CROSS_TOP}/SDKs/${CROSS_SDK} -mios-version-min=${MIN_IOS_VERSION} !" "Makefile"
	echo "make clean"
		make clean  >> "/tmp/${OPENSSL_VERSION}-iOS-${ARCH}.log" 2>&1
	echo "make"
		make >> "/tmp/${OPENSSL_VERSION}-iOS-${ARCH}.log" 2>&1
	echo "make install"
		make install >> "/tmp/${OPENSSL_VERSION}-iOS-${ARCH}.log" 2>&1
	popd > /dev/null
	echo "Done Building ${OPENSSL_VERSION} for ${ARCH}"
}

#downloadOpenSSL $OPENSSL_VERSION

buildIOS "x86_64"
buildIOS "arm64"

echo "Building iOS libraries"

mkdir "./build/${OPENSSL_VERSION}/lib"

lipo "/tmp/${OPENSSL_VERSION}-iOS-arm64/lib/libcrypto.a" "/tmp/${OPENSSL_VERSION}-iOS-x86_64/lib/libcrypto.a" -create -output "./build/${OPENSSL_VERSION}/lib/libcrypto.a"
lipo "/tmp/${OPENSSL_VERSION}-iOS-arm64/lib/libssl.a" "/tmp/${OPENSSL_VERSION}-iOS-x86_64/lib/libssl.a" -create -output "./build/${OPENSSL_VERSION}/lib/libssl.a"

echo "Cleaning up"

#rm -rf /tmp/${OPENSSL_VERSION}-*