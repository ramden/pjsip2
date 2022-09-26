#
# Be sure to run `pod lib lint pjsip-ios.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "pjproject-ios"
  s.version          = "2.12.1"
  s.summary          = "PJSIP"
  s.description      = <<-DESC
                       This pjsip Pod enables iOS application to integrate the pjsip library as a cocoapod.
                       DESC
  s.homepage         = "https://git.nfon.net/"
  s.license          = 'MIT'
  s.author           = { "Cloudia iOS Team" => "jannis.muething@ext.nfon.com" }
  s.source           = { :git => "https://git.nfon.net/scm/zeb/pjproject-ios.git", :tag => s.version.to_s }

  s.platform     = :ios, '13.0'
  s.requires_arc = false

  s.public_header_files = 'Pod/pjsip-include/**/**/*.{h,hpp}'
  s.source_files = 'Pod/pjsip-include/**/**/*.{h,hpp}'
  s.preserve_paths = 'Pod/pjsip-lib/**/**/*{a}'
  s.frameworks = 'CFNetwork', 'AudioToolbox', 'AVFoundation', 'Security', 'Network'

  s.header_mappings_dir = 'Pod'

  # s.dependency 'OpenSSL-Universal', '1.1.1501'

  s.xcconfig = {
    'GCC_PREPROCESSOR_DEFINITIONS' => 'PJ_AUTOCONF=1',
    'HEADER_SEARCH_PATHS'  => '$(inherited) "$(PODS_ROOT)/pjproject-ios/Pod/pjsip-include"',
    'LIBRARY_SEARCH_PATHS[sdk=iphonesimulator*]' => '$(PODS_ROOT)/pjproject-ios/Pod/pjsip-lib/simulator',
    'LIBRARY_SEARCH_PATHS[sdk=iphoneos*]' => '$(PODS_ROOT)/pjproject-ios/Pod/pjsip-lib/device',
    'OTHER_LDFLAGS[sdk=iphonesimulator*]' => '$(inherited) -l"g7221codec-armv-apple-darwin_ios-1" -l"gsmcodec-armv-apple-darwin_ios-1"  -l"ilbccodec-armv-apple-darwin_ios-1" -l"pj-armv-apple-darwin_ios-1" -l"pjlib-util-armv-apple-darwin_ios-1"  -l"pjmedia-armv-apple-darwin_ios-1" -l"pjmedia-audiodev-armv-apple-darwin_ios-1" -l"pjmedia-codec-armv-apple-darwin_ios-1"  -l"pjmedia-videodev-armv-apple-darwin_ios-1" -l"pjnath-armv-apple-darwin_ios-1" -l"pjsdp-armv-apple-darwin_ios-1"  -l"pjsip-armv-apple-darwin_ios-1" -l"pjsip-simple-armv-apple-darwin_ios-1" -l"pjsip-ua-armv-apple-darwin_ios-1"  -l"pjsua-armv-apple-darwin_ios-1" -l"pjsua2-armv-apple-darwin_ios-1" -l"resample-armv-apple-darwin_ios-1" -l"speex-armv-apple-darwin_ios-1"  -l"srtp-armv-apple-darwin_ios-1" -l"webrtc-armv-apple-darwin_ios-1" -l"yuv-armv-apple-darwin_ios-1" -framework "AVFoundation" -framework "AudioToolbox" -framework "CFNetwork" -framework "Security" -framework "Network"',
    'OTHER_LDFLAGS[sdk=iphoneos*]' => '$(inherited) -l"g7221codec-armv-apple-darwin_ios-0" -l"gsmcodec-armv-apple-darwin_ios-0"  -l"ilbccodec-armv-apple-darwin_ios-0" -l"pj-armv-apple-darwin_ios-0" -l"pjlib-util-armv-apple-darwin_ios-0"  -l"pjmedia-armv-apple-darwin_ios-0" -l"pjmedia-audiodev-armv-apple-darwin_ios-0" -l"pjmedia-codec-armv-apple-darwin_ios-0"  -l"pjmedia-videodev-armv-apple-darwin_ios-0" -l"pjnath-armv-apple-darwin_ios-0" -l"pjsdp-armv-apple-darwin_ios-0" -l"pjsip-armv-apple-darwin_ios-0" -l"pjsip-simple-armv-apple-darwin_ios-0" -l"pjsip-ua-armv-apple-darwin_ios-0"  -l"pjsua-armv-apple-darwin_ios-0" -l"pjsua2-armv-apple-darwin_ios-0" -l"resample-armv-apple-darwin_ios-0"  -l"speex-armv-apple-darwin_ios-0" -l"srtp-armv-apple-darwin_ios-0" -l"webrtc-armv-apple-darwin_ios-0" -l"yuv-armv-apple-darwin_ios-0" -framework "AVFoundation" -framework "AudioToolbox" -framework "CFNetwork" -framework "Security" -framework "Network"'
  }
end
