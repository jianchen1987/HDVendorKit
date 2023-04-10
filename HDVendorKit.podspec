Pod::Spec.new do |s|
  s.name             = "HDVendorKit"
  s.version          = "0.4.5"
  s.summary          = "混沌 iOS 对第三方服务的封装"
  s.description      = <<-DESC
                       HDVendorKit 是一系列基础能力，比如网络请求、图片加载等，用于快速在其他项目使用或者第三方接入
                       DESC
  s.homepage         = "https://code.kh-super.net/projects/MOB/repos/hdvendorkit"
  s.license          = 'MIT'
  s.author           = {"VanJay" => "wangwanjie1993@gmail.com"}
  s.source           = {:git => "ssh://git@code.kh-super.net:7999/mob/hdvendorkit.git", :tag => s.version.to_s}
  s.social_media_url = 'https://code.kh-super.net/projects/MOB/repos/hdvendorkit'
  s.requires_arc     = true
  s.documentation_url = 'https://code.kh-super.net/projects/MOB/repos/hdvendorkit'

  s.platform         = :ios, '9.0'

  $lib = ENV['use_lib']
  $lib_name = ENV["#{s.name}_use_lib"]
  if $lib || $lib_name
    puts '--------- HDVendorKit binary -------'

    s.frameworks       = 'Foundation', 'UIKit'
    s.ios.vendored_framework = "#{s.name}-#{s.version}/ios/#{s.name}.framework"
    s.resources = "#{s.name}-#{s.version}/ios/#{s.name}.framework/Versions/A/Resources/*.bundle"
    s.dependency 'AFNetworking', '~> 4.0'
    s.dependency 'SDWebImage', '~> 5.10'
  else
    puts '....... HDVendorKit source ........'

    s.frameworks       = 'Foundation', 'UIKit'
    s.source_files     = 'HDVendorKit/HDVendorKit.h'

    s.subspec 'ObjcAssociatedObjectHelpers' do |ss|
      ss.source_files = 'HDVendorKit/ObjcAssociatedObjectHelpers'
    end

    s.subspec 'TOTPGenerator' do |ss|
      ss.source_files = 'HDVendorKit/TOTPGenerator'
    end

    s.subspec 'AFNetworking+Retry' do |ss|
      ss.source_files = 'HDVendorKit/AFNetworking+Retry'
      ss.dependency 'HDVendorKit/ObjcAssociatedObjectHelpers'
      ss.dependency 'AFNetworking', '~> 4.0'
    end

    s.subspec 'HDWebImageManager' do |ss|
      ss.source_files = 'HDVendorKit/HDWebImageManager'
      ss.dependency 'SDWebImage', '~> 5.10'
      ss.dependency 'HDKitCore/Core'
    end
    
    s.subspec 'WNFMDBManager' do |ss|
        ss.source_files = 'HDVendorKit/WNFMDBManager/**/*'
        ss.dependency 'FMDB'
      end
    
    
  end
end
