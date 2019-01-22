Pod::Spec.new do |s|
    s.name             = "ZippyIdSDK"
    s.version          = "0.9"
    s.summary          = "Zippy ID (zippyid.com) SDK for iOS"
    s.license          = 'MIT'
    s.author           = { "MAK IT" => "makit.lv" } 
    s.source           = { :git => "https://github.com/mak-it/zippy-id-sdk-ios.git", :tag => s.version }
    s.homepage         = "zippyid.com"
    s.platform         = :ios, '10.0'
    s.source_files     = 'ZippyIdSDK/**/*.{swift}'
    s.resources        = "ZippyIdSDK/**/*.{storyboard,xcassets}"
end
