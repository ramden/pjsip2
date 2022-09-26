#!/bin/sh

# PJSIP build script
# ./build.sh [pjsip version tag or branch name on github] [0 (default): don't build openSSL (not needed; just recommended to see errors workings), 1: do build openSSL] [list of all supported architectures: possible values & default: arm64 x86_64]
# Example: ./build.sh 2.10 0 arm64 x86_64

# see http://stackoverflow.com/a/3915420/318790
function realpath { echo $(cd $(dirname "$1"); pwd)/$(basename "$1"); }

BUILD_DIR=$(realpath "build")
if [ ! -d ${BUILD_DIR} ]; then
    mkdir ${BUILD_DIR}
fi


PJSIP_GIT_URL="https://github.com/pjsip/pjproject"
PJSIP_GIT_DIR=${BUILD_DIR}/`basename ${PJSIP_GIT_URL}`
PJSIP_GIT_VERSION_NUMBER_TAG=${1-2.12.1}
IOS_DEPLOYMENT_TARGET="13.0"
BUILD_OPENSSL=${2-0}
shift 2
ARCHITECTURES=("arm64" "arm64" "x86_64")
ISSIMULATOR=(1 0 1)
OPENSSL_UNIVERSAL_VERSION_NUMBER_TAG="1.1.180"


export OPENSSL_LDFLAGS="-framework Network -framework Security"


function copy_includes() {
    PJSIPDIR=${1}

    if [ -d ../../Pod/pjsip-include/ ]; then
        rm -rf ../../Pod/pjsip-include/
    fi
    if [ ! -d ../../Pod/pjsip-include/ ]; then
        mkdir ../../Pod/pjsip-include/
    fi

    cp -R "./pjlib/include/" "../../Pod/pjsip-include/"
    cp -R "./pjlib-util/include/" "../../Pod/pjsip-include/"
    cp -R "./pjmedia/include/" "../../Pod/pjsip-include/"
    cp -R "./pjnath/include/" "../../Pod/pjsip-include/"
    cp -R "./pjsip/include/" "../../Pod/pjsip-include/"
}

function copy_libs () {
    DST=${1}
    SIMULATOR=${2}

    echo "copy arch: lib-${DST}"

    if [ -d .././lib-${DST}-${SIMULATOR}/ ]; then
        rm -rf pjlib/lib-${DST}-${SIMULATOR}/
    fi
    if [ ! -d pjlib/lib-${DST}-${SIMULATOR}/ ]; then
        mkdir pjlib/lib-${DST}-${SIMULATOR}/
    fi
    cp -a pjlib/lib/ pjlib/lib-${DST}-${SIMULATOR}/

    if [ -d pjlib-util/lib-${DST}-${SIMULATOR}/ ]; then
        rm -rf pjlib-util/lib-${DST}-${SIMULATOR}/
    fi
    if [ ! -d pjlib-util/lib-${DST}-${SIMULATOR}/ ]; then
        mkdir pjlib-util/lib-${DST}-${SIMULATOR}/
    fi
    cp -a pjlib-util/lib/ pjlib-util/lib-${DST}-${SIMULATOR}/

    if [ -d pjmedia/lib-${DST}-${SIMULATOR}/ ]; then
        rm -rf pjmedia/lib-${DST}-${SIMULATOR}/
    fi
    if [ ! -d pjmedia/lib-${DST}-${SIMULATOR}/ ]; then
        mkdir pjmedia/lib-${DST}-${SIMULATOR}/
    fi
    cp -a pjmedia/lib/ pjmedia/lib-${DST}-${SIMULATOR}/

    if [ -d pjnath/lib-${DST}-${SIMULATOR}/ ]; then
        rm -rf pjnath/lib-${DST}-${SIMULATOR}/
    fi
    if [ ! -d pjnath/lib-${DST}-${SIMULATOR}/ ]; then
        mkdir pjnath/lib-${DST}-${SIMULATOR}/
    fi
    cp -a pjnath/lib/ pjnath/lib-${DST}-${SIMULATOR}/

    if [ -d pjsip/lib-${DST}-${SIMULATOR}/ ]; then
        rm -rf pjsip/lib-${DST}-${SIMULATOR}/
    fi
    if [ ! -d pjsip/lib-${DST}-${SIMULATOR}/ ]; then
        mkdir pjsip/lib-${DST}-${SIMULATOR}/
    fi
    cp -a pjsip/lib/ pjsip/lib-${DST}-${SIMULATOR}/

    if [ -d third_party/lib-${DST}-${SIMULATOR}/ ]; then
        rm -rf third_party/lib-${DST}-${SIMULATOR}/
    fi
    if [ ! -d third_party/lib-${DST}-${SIMULATOR}/ ]; then
        mkdir third_party/lib-${DST}-${SIMULATOR}/
    fi
    cp -a third_party/lib/ third_party/lib-${DST}-${SIMULATOR}/
}

function clean() {
    rm -rf pjlib/lib/
    rm -rf pjlib-util/lib/
    rm -rf pjmedia/lib/
    rm -rf pjnath/lib/
    rm -rf pjsip/lib/
    rm -rf third_party/lib/
}

function liboForArchs() {
    formatString=${1}
    output=${2}

    liboArchsString=""

	for ((idx=0; idx<${#ARCHITECTURES[@]}; ++idx)); do
	   :
        if [ ${ISSIMULATOR[idx]} == 0 ]; then 
            continue;
        fi
	   currentLib=$(echo "${formatString}" | sed "s/XXX/${ARCHITECTURES[idx]}/g")
	   echo "old string: ${formatString}"
	   echo "new  string: ${currentLib}"
       liboArchsString="${liboArchsString} ${currentLib}"
	done 


	simulatorString=$(echo "${liboArchsString}" | sed "s/JJJ/1/g")
	simulatorOutput=$(echo "${output}" | sed "s/JJJ/1/g")
    echo "simulator lib ${simulatorString}"
    xcrun -sdk iphonesimulator lipo ${simulatorString} -create -output  ${simulatorOutput}

    liboArchsString=""

    for ((idx=0; idx<${#ARCHITECTURES[@]}; ++idx)); do
       :
        if [ ${ISSIMULATOR[idx]} == 1 ]; then 
            continue;
        fi
       currentLib=$(echo "${formatString}" | sed "s/XXX/${ARCHITECTURES[idx]}/g")
       echo "old string: ${formatString}"
       echo "new  string: ${currentLib}"
       liboArchsString="${liboArchsString} ${currentLib}"
    done 

	deviceString=$(echo "${liboArchsString}" | sed "s/JJJ/0/g")
	deviceOutput=$(echo "${output}" | sed "s/JJJ/0/g")

    echo "device lib ${deviceString}"
    xcrun -sdk iphoneos lipo ${deviceString} -create -output  ${deviceOutput}
}

function llipo_libs_arch () {
    liboForArchs "-arch XXX pjlib/lib-XXX-JJJ/libpj-XXX-apple-darwin_ios.a" "lib/libpj-armv-apple-darwin_ios-JJJ.a"
    liboForArchs "-arch XXX pjmedia/lib-XXX-JJJ/libpjmedia-XXX-apple-darwin_ios.a" "lib/libpjmedia-armv-apple-darwin_ios-JJJ.a"
    liboForArchs "-arch XXX pjmedia/lib-XXX-JJJ/libpjmedia-audiodev-XXX-apple-darwin_ios.a" "lib/libpjmedia-audiodev-armv-apple-darwin_ios-JJJ.a"
    liboForArchs "-arch XXX pjmedia/lib-XXX-JJJ/libpjmedia-codec-XXX-apple-darwin_ios.a" "lib/libpjmedia-codec-armv-apple-darwin_ios-JJJ.a"
    liboForArchs "-arch XXX pjmedia/lib-XXX-JJJ/libpjmedia-videodev-XXX-apple-darwin_ios.a" "lib/libpjmedia-videodev-armv-apple-darwin_ios-JJJ.a"
    liboForArchs "-arch XXX pjmedia/lib-XXX-JJJ/libpjsdp-XXX-apple-darwin_ios.a" "lib/libpjsdp-armv-apple-darwin_ios-JJJ.a" 
    liboForArchs "-arch XXX pjnath/lib-XXX-JJJ/libpjnath-XXX-apple-darwin_ios.a" "lib/libpjnath-armv-apple-darwin_ios-JJJ.a" 
    liboForArchs "-arch XXX pjsip/lib-XXX-JJJ/libpjsip-XXX-apple-darwin_ios.a" "lib/libpjsip-armv-apple-darwin_ios-JJJ.a" 
    liboForArchs "-arch XXX pjsip/lib-XXX-JJJ/libpjsip-simple-XXX-apple-darwin_ios.a" "lib/libpjsip-simple-armv-apple-darwin_ios-JJJ.a" 
    liboForArchs "-arch XXX pjsip/lib-XXX-JJJ/libpjsip-ua-XXX-apple-darwin_ios.a" "lib/libpjsip-ua-armv-apple-darwin_ios-JJJ.a" 
    liboForArchs "-arch XXX pjsip/lib-XXX-JJJ/libpjsua-XXX-apple-darwin_ios.a" "lib/libpjsua-armv-apple-darwin_ios-JJJ.a" 
    liboForArchs "-arch XXX pjsip/lib-XXX-JJJ/libpjsua2-XXX-apple-darwin_ios.a" "lib/libpjsua2-armv-apple-darwin_ios-JJJ.a" 
    liboForArchs "-arch XXX pjlib-util/lib-XXX-JJJ/libpjlib-util-XXX-apple-darwin_ios.a" "lib/libpjlib-util-armv-apple-darwin_ios-JJJ.a" 
    liboForArchs "-arch XXX third_party/lib-XXX-JJJ/libsrtp-XXX-apple-darwin_ios.a" "lib/libsrtp-armv-apple-darwin_ios-JJJ.a" 
    liboForArchs "-arch XXX third_party/lib-XXX-JJJ/libg7221codec-XXX-apple-darwin_ios.a" "lib/libg7221codec-armv-apple-darwin_ios-JJJ.a" 
    liboForArchs "-arch XXX third_party/lib-XXX-JJJ/libgsmcodec-XXX-apple-darwin_ios.a" "lib/libgsmcodec-armv-apple-darwin_ios-JJJ.a" 
    liboForArchs "-arch XXX third_party/lib-XXX-JJJ/libilbccodec-XXX-apple-darwin_ios.a" "lib/libilbccodec-armv-apple-darwin_ios-JJJ.a" 
    liboForArchs "-arch XXX third_party/lib-XXX-JJJ/libresample-XXX-apple-darwin_ios.a" "lib/libresample-armv-apple-darwin_ios-JJJ.a" 
    liboForArchs "-arch XXX third_party/lib-XXX-JJJ/libspeex-XXX-apple-darwin_ios.a" "lib/libspeex-armv-apple-darwin_ios-JJJ.a" 
    liboForArchs "-arch XXX third_party/lib-XXX-JJJ/libyuv-XXX-apple-darwin_ios.a" "lib/libyuv-armv-apple-darwin_ios-JJJ.a" 
    liboForArchs "-arch XXX third_party/lib-XXX-JJJ/libwebrtc-XXX-apple-darwin_ios.a" "lib/libwebrtc-armv-apple-darwin_ios-JJJ.a" 
}

function list_include_item {
  item=${1}
  shift
  list=${@}
  if [[ $list =~ (^|[[:space:]])"$item"($|[[:space:]]) ]] ; then
    return 0
  else
    return 1
  fi
}

function prepareOpenSSL {
	if [ ${BUILD_OPENSSL} -eq 1 ]; then
        echo "Building openssl..."
        sh build-openssl.sh ${OPENSSL_VERSION}
        OPENSSL_HEADERS=${OPENSSL_DIR}/include
        export OPENSSL_CFLAGS="-I${OPENSSL_HEADERS}"
        export OPENSSL_LDFLAGS="-L${OPENSSL_LIB_DIR}"
    else
        if [ -d ${BUILD_DIR}/OpenSSL ]; then
           echo "Cleaning up... OpenSSL"
           rm -rf ${BUILD_DIR}/OpenSSL
        fi

        echo "Downloading openssl universal..."

        BRANCH="1.1.180"
        if [ -z ${OPENSSL_UNIVERSAL_VERSION_NUMBER_TAG+x} ]; then echo "No OpenSSL Universal version tag. Using default"; else 
            BRANCH="${OPENSSL_UNIVERSAL_VERSION_NUMBER_TAG}"
        fi

        git clone --depth 1 -c advice.detachedHead=false --branch ${BRANCH} "https://github.com/krzyzanowskim/OpenSSL.git" ${BUILD_DIR}/OpenSSL
    fi
}

function setupOpenSSLForSimulator() {
	echo "setupOpenSSLForSimulator... "

	# export OPENSSL_DIR="${BUILD_DIR}/OpenSSL/iphonesimulator"

 #    export OPENSSL_LIB_DIR="${OPENSSL_DIR}/lib"
 #    export OPENSSL_HEADERS=${OPENSSL_DIR}/include

 #    export OPENSSL_CFLAGS="-I${OPENSSL_HEADERS}"
 #    export OPENSSL_LDFLAGS="-L${OPENSSL_LIB_DIR}"
 #    echo "OPENSSL_LDFLAGS: ${OPENSSL_LDFLAGS}"
 #    echo "OPENSSL_CFLAGS: ${OPENSSL_CFLAGS}"
}

function setupOpenSSLForDevice() {
	echo "setupOpenSSLForDevice... "

	# export OPENSSL_DIR="${BUILD_DIR}/OpenSSL/iphoneos"

 #    export OPENSSL_LIB_DIR="${OPENSSL_DIR}/lib"
 #    export OPENSSL_HEADERS=${OPENSSL_DIR}/include

 #    export OPENSSL_CFLAGS="-I${OPENSSL_HEADERS}"
 #    export OPENSSL_LDFLAGS="-L${OPENSSL_LIB_DIR}"


 #    echo "OPENSSL_LDFLAGS: ${OPENSSL_LDFLAGS}"
 #    echo "OPENSSL_CFLAGS: ${OPENSSL_CFLAGS}"
}

function downloadPJSIP {
    if [ -d ${PJSIP_GIT_DIR} ]; then
       echo "Cleaning up..."
       rm -rf ${PJSIP_GIT_DIR}
    fi

    echo "Downloading pjsip..."

    BRANCH=""
    if [ -z ${PJSIP_GIT_VERSION_NUMBER_TAG+x} ]; then echo "No PJSIP version tag specified. Using master branch..."; else 
        BRANCH="-b ${PJSIP_GIT_VERSION_NUMBER_TAG}"
    fi

    git clone ${BRANCH} --single-branch --depth 1 -c advice.detachedHead=false ${PJSIP_GIT_URL}  ${PJSIP_GIT_DIR}
}

function _build() {
	TARTGET_ARCH=$1
	SIMULATOR=$2
    export EXCLUDED_ARCHS="i386 armv7"
	if [ ${SIMULATOR} == 1 ]; then 
		setupOpenSSLForSimulator 
		echo "${TARTGET_ARCH} for SIMULATOR"
        # export CC="${DEVPATH}/usr/bin/llvm-gcc"
        export MIN_IOS="-mios-simulator-version-min=${IOS_DEPLOYMENT_TARGET}"
        export IPHONESDK="`xcrun -sdk iphonesimulator --show-sdk-path`"
		export DEVPATH="`xcrun -sdk iphonesimulator --show-sdk-platform-path`/Developer"
 		export CFLAGS="${OPENSSL_CFLAGS} -O2 -m64 -mios-simulator-version-min=${IOS_DEPLOYMENT_TARGET}"
 		export LDFLAGS="${OPENSSL_LDFLAGS} -O2 -m64 -mios-simulator-version-min=${IOS_DEPLOYMENT_TARGET}"
 	else
        export MIN_IOS="-miphoneos-version-min=${IOS_DEPLOYMENT_TARGET}"
        export IPHONESDK="`xcrun -sdk iphoneos --show-sdk-path`"
        export DEVPATH="`xcrun -sdk iphoneos --show-sdk-platform-path`/Developer"
 		setupOpenSSLForDevice
 		echo "${TARTGET_ARCH} not for SIMULATOR"

 		unset DEVPATH
 		export CFLAGS="${OPENSSL_CFLAGS} -O2"
 		export LDFLAGS="${OPENSSL_LDFLAGS}"
 	fi

	LOG=${BUILD_DIR}/${TARTGET_ARCH}-${SIMULATOR}.log

	echo "Building for ${TARTGET_ARCH} with ${OPENSSL_DIR}..."

    echo "CFLAGS: ${CFLAGS}"
    echo "LDFLAGS: ${LDFLAGS}"
    clean

	export ARCH="-arch ${TARTGET_ARCH}"
 
 
	./configure-iphone >> ${LOG} 2>&1
    echo "CONFIG DONE?"

	make dep >> ${LOG} 2>&1
	make clean >> ${LOG}
	make >> ${LOG} 2>&1

	copy_libs $TARTGET_ARCH $SIMULATOR
}

buildPJSIP() {
	cd ${PJSIP_GIT_DIR}

	for ((idx=0; idx<${#ARCHITECTURES[@]}; ++idx)); do
	   :
	   _build ${ARCHITECTURES[idx]} ${ISSIMULATOR[idx]}
	   echo "index: $idx ${ISSIMULATOR[idx]}"
	done

	echo "Making universal lib..."
	make distclean > /dev/null

	mkdir ${PJSIP_GIT_DIR}/lib

	llipo_libs_arch

    mkdir ../../Pod/pjsip-lib/device
    mkdir ../../Pod/pjsip-lib/simulator
	cp lib/*-0.a ../../Pod/pjsip-lib/device
    cp lib/*-1.a ../../Pod/pjsip-lib/simulator

	copy_includes
}

rm -rf ./Pod/pjsip-lib/*
rm -rf ./Pod/pjsip-include/*

sed -Ei '' 's/(version[[:space:]]*=[[:space:]]*")(.*)*(")/\1'${PJSIP_GIT_VERSION_NUMBER_TAG}'\3/g' pjproject-ios.podspec
downloadPJSIP
echo "Creating config.h..."
cp config_site.h ${PJSIP_GIT_DIR}/pjlib/include/pj/config_site.h
prepareOpenSSL
buildPJSIP

echo "Done"
