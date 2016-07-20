Pod::Spec.new do |spec|
  spec.platform = :ios
  spec.ios.deployment_target = '8.0'
  spec.name         = 'NNetworking'
  spec.requires_arc    = true
  spec.version         = '1.0'
  spec.license      = 'MIT'
  spec.homepage     = 'https://github.com/nhan07t1/NNetwoking'
  spec.authors      = { 'NhanNguyen' => 'ngocnhan07t1@gmail.com' }
  spec.summary      = 'NNetworking is network manage'
  spec.source       = { :git => 'https://github.com/nhan07t1/NNetwoking.git', :tag => spec.version }
  spec.framework = 'UIKit'
  spec.framework = 'CoreLocation'
  spec.framework    = 'SystemConfiguration'
  spec.dependency 'AFNetworking', '~> 2.5.4'
  spec.dependency 'JSONModel', '~> 1.2.0'
  spec.source_files = 'NNetworking/**/*.{swift,h,m}'
  
end