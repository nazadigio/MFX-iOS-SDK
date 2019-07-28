#
# Be sure to run `pod lib lint MFXSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "MFXSDK_AdMobAdapter"
  s.version          = "4.0.0"
  s.summary          = "MobFox's iOS AdMob Adapter"

wd = "Working Dir: %s" % [Dir.pwd]

puts wd
  
#puts ENV #$(PODS_ROOT)

#puts ENV['PODS_ROOT']

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = "MobFox's iOS SDK Used To Get Ads From The MobFox SSP"

  s.homepage         = "https://www.mobfox.com/"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { "MobFox" => "ofir.ka@mobfox.com"  }
  s.source           = { :git => 'https://github.com/mobfox/MFX-iOS-SDK.git', :tag => "#{s.version}" }

  puts   s.source

  s.ios.deployment_target = '9.0'
  s.static_framework = true
  s.requires_arc = true

  s.ios.libraries = 'z'

  s.source_files = 'Adapters/AdMob/*.{h,m}'
  # s.ios.source_files = 'Adapters/AdMob/**/*.{h,m}'


  s.vendored_frameworks = 'MFXSDKCore.embeddedframework/MFXSDKCore.framework'

  s.dependency 'Google-Mobile-Ads-SDK', '= 7.40.0'
  #s.dependency 'mopub-ios-sdk', '5.0'
end