
Pod::Spec.new do |s|
  s.name     = "RXAddImagesView"
  s.version  = "0.1"
  s.license  = "MIT"
  s.summary  = "RXAddImagesView is a simple weixin view"
  s.homepage = "https://github.com/xzjxylophone/RXAddImagesView"
  s.author   = { 'Rush.D.Xzj' => 'xzjxylophoe@gmail.com' }
  s.social_media_url = "http://weibo.com/xzjxylophone"
  s.source   = { :git => 'https://github.com/xzjxylophone/RXAddImagesView.git', :tag => "v#{s.version}" }
  s.description = %{
        RXAddImagesView is a simple weixin view.
  }
  s.source_files = 'RXAddImagesView/*.{h,m}'
  s.frameworks = 'Foundation', 'UIKit'
  s.requires_arc = true
  s.platform = :ios, '7.0'
  s.dependency 'TZImagePickerController'

end



