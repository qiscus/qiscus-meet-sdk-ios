Pod::Spec.new do |s|
  s.name             = 'QiscusMeet'
  s.version          = '0.3.0'
  s.summary          = 'Qiscus Meet iOS SDK'
  s.description      = 'Qiscus Meet is a WebRTC compatible, free and Open Source video conferencing system that provides browsers and mobile applications with Real Time Communications capabilities.'
  s.homepage         = 'https://documentation.qiscus.com/qiscus-meet/introduction'
  s.license          = 'Apache 2'
  s.authors          = 'Qiscus'
  s.source           = { :git => 'https://github.com/qiscus/qiscus-sdk-meet-ios.git', :tag => s.version }
  s.social_media_url = 'https://qiscus.com'
  s.swift_version    = '4.1'
  s.source_files     = "QiscusMeet/**/*.{swift}"
  s.resource_bundles = {
    'QiscusMeet' => ['QiscusMeet/**/*.{xib,xcassets,imageset,png}']
  }

  s.platform         = :ios, '10.0'

  s.vendored_frameworks = 'SDK/JitsiMeet.framework', 'SDK/WebRTC.framework'
  s.dependency 'Alamofire'
  s.dependency 'SwiftyJSON'
end
