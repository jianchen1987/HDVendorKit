Pod::Spec.new do |s|
  s.name             = "HDVendorKit"
  s.version          = "0.1.5"
  s.summary          = "混沌 iOS 基础能力"
  s.description      = <<-DESC
                       HDVendorKit 是一系列基础能力，比如网络请求、图片加载等，用于快速在其他项目使用或者第三方接入
                       DESC
  s.homepage         = "https://git.vipaylife.com/vipay/HDVendorKit"
  s.license          = 'MIT'
  s.author           = {"VanJay" => "wangwanjie1993@gmail.com"}
  s.source           = {:git => "git@git.vipaylife.com:vipay/HDVendorKit.git", :tag => s.version.to_s}
  s.social_media_url = 'https://git.vipaylife.com/vipay/HDVendorKit'
  s.requires_arc     = true
  s.documentation_url = 'https://git.vipaylife.com/vipay/HDVendorKit'
  s.screenshot       = 'https://xxx.png'

  s.platform         = :ios, '9.0'
  s.frameworks       = 'Foundation', 'UIKit'
  s.source_files     = 'HDVendorKit/HDVendorKit.h'

  s.subspec 'KVOController' do |ss|
    ss.source_files = 'HDVendorKit/FBKVOController'
  end

  s.subspec 'HDWeakTimer' do |ss|
    ss.source_files = 'HDVendorKit/HDWeakTimer'
  end

  s.subspec 'ObjcAssociatedObjectHelpers' do |ss|
    ss.source_files = 'HDVendorKit/ObjcAssociatedObjectHelpers'
  end

  s.subspec 'Foundation+HDLog' do |ss|
    ss.source_files = 'HDVendorKit/Foundation+HDLog'
  end

  s.subspec 'TOTPGenerator' do |ss|
    ss.source_files = 'HDVendorKit/TOTPGenerator'
  end

  s.subspec 'AFNetworking+Retry' do |ss|
    ss.source_files = 'HDVendorKit/AFNetworking+Retry'
    ss.dependency 'HDVendorKit/ObjcAssociatedObjectHelpers'
    ss.dependency 'AFNetworking', '~> 3.0.0'
  end

  s.subspec 'HDWebImageManager' do |ss|
    ss.source_files = 'HDVendorKit/HDWebImageManager'
    ss.dependency 'SDWebImage', '~> 5.3.3'
    ss.dependency 'HDUIKit/Core'
  end
end
