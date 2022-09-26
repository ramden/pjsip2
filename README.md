

# pjproject-ios

This is a cocoa pod that makes the pjsip library available for useage in iOS apps. 
To install it imply put the follwing into you Podfile:

```
pod 'pjproject-ios', :git => 'ssh://git@git.nfon.net/zeb/pjproject-ios.git'
```

The 'build.sh' script is responsible for downloading current pjsip library, preparing its dependencies and building it for all required architectures. Adopt the script to point it to the most up-to-date library and run it.

The library is usable as a cocoapod. Consequently all required files (merge products of all architecture builds) are copied into the Pod directory of this project.

Note:

Downloading and building OpenSSL is not really required during build time. The library will be linked during runtime when this library is used. During build time - when the default parameter is selected - unresolved references are ignored (-Wl,-undefined,dynamic_lookup) and are looked up dynamically during runtime. This should be avoided when working on the pjsip library itself as errors will not be reported at build time, but can be OK if we are just updating the library. OpenSSL headers or binary files are also never exported to the pod users. OpenSSL should stay a peer dependency of this pod - not be bundled with it. 

## Updating

Updating the library is as simple as executing

```
build.sh [new version number]
```

This will download, build and prepare the new version for arm64 and x86_64 without downloading and building openSSL. The version passed to the script will also be written into the podspec file.

## Usage: 

```
./build.sh [pjsip version tag or branch name on github (2.10 by default)] [0 (default): don't build openSSL (instead OPENSSL Universal will be downloaded), 1: do build openSSL (not recommended)] [list of all supported architectures: possible values & default: arm64 x86_64]
```

Note: there are some issues when building open ssl from source and using this built to build pjsip. So its recommended to use the 0 (default) option. This will download the prebuild OpenSSL binaries that are also used in the client app. 

### Example:

0.
```
./build.sh
```
Downloads and builds the default version specified in build.sh (currently 2.10), without openssl and for arm64 and x86_64

1.
```
./build.sh 2.10
```
Downloads the version 2.10 tag from pjsips github repository.

2.
```
./build.sh 2.8 1 arm64
```
Downloads the version 2.8 tag from pjsips github repository, downloads and build openSSL and will throw errors during build if references are undefined..., will also only build the arm64 library


## Configuration

The PJSIP library build configuration happens by modifying the 'config_site.h' file on the top level of this directory.

Here the support for optional features can be controlled before the build is started. Thus yielding a custom tailored library for Cloudya:

```
#define PJMEDIA_HAS_INTEL_IPP_CODEC_G722_1 0 // codec support disabled
#define PJMEDIA_HAS_G722_CODEC 1 // codec support enabled

/*
* TLS transport and SRTP support must enabled!
*/
#define PJ_HAS_SSL_SOCK 1
#define PJSIP_HAS_TLS_TRANSPORT 1
#define PJMEDIA_HAS_SRTP 1
```