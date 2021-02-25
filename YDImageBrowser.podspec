Pod::Spec.new do |s|
  s.name             = 'YDImageBrowser'
  s.version          = '0.1.1'
  s.summary          = 'iOS仿微信图片浏览器.'
  s.homepage         = 'https://github.com/CoderThink/YDImageBrowser'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Think' => '269248588@qq.com' }
  s.source           = { :git => 'https://github.com/CoderThink/YDImageBrowser.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  
  s.default_subspec = 'SD'
  
  s.subspec 'Core' do |core|
    core.source_files = 'YDImageBrowser/Classes/Core/*'
  end

  s.subspec 'SD' do |sd|
    sd.source_files = 'YDImageBrowser/Classes/SDWebImage/*'
    sd.dependency 'YDImageBrowser/Core'
    sd.dependency 'SDWebImage'
  end

  s.subspec 'YY' do |yy|
    yy.source_files = 'YDImageBrowser/Classes/YYWebImage'
    yy.dependency 'YDImageBrowser/Core'
    yy.dependency 'YYWebImage'
  end
  
end
