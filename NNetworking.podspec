Pod::Spec.new do |spec|
  spec.name         = 'NNetworking'
  spec.version      = '1.0.1'
  spec.license      = { :type => 'BSD' }
  spec.homepage     = 'https://github.com/nhan07t1/NNetwoking'
  spec.authors      = { 'NhanNguyen' => 'ngocnhan07t1@gmail.com' }
  spec.summary      = 'ARC and GCD Compatible Reachability Class for iOS and OS X.'
  spec.source       = { :git => 'https://github.com/nhan07t1/NNetwoking.git', :tag => 'v1.0.1' }
  spec.framework = 'UIKit'
  spec.framework = 'CoreLocation'
  spec.framework    = 'SystemConfiguration'
  spec.dependency 'AFNetworking', '~> 2.5.4'
  spec.dependency 'JSONModel', '~> 1.2.0'
  spec.source_files = "NNetworking/**/*.{swift,h,m}"
  
end