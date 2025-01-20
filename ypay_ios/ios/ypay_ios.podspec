#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint ypay_ios.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.static_framework = true 
  s.name             = 'ypay_ios'
  s.version          = '1.0.3'
  s.summary          = 'YPay iOS SDK Plugin'
  s.description      = <<-DESC
The implementation of 'ypay' plugin for the iOS platform
                       DESC
  s.homepage         = 'https://thehead.ru/'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'The Head' => 'think@thehead.ru' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'YandexPaySDK/Static'
  s.dependency 'Flutter'
  s.platform = :ios, '14.0'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386 arm64' }
  s.swift_version = '5.0'
end
