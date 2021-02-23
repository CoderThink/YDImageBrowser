Pod::Spec.new do |s|
  s.name             = 'YDImageBrowser'
  s.version          = '0.1.0'
  s.summary          = 'iOS仿微信图片浏览器.'
  s.homepage         = 'https://github.com/CoderThink/YDImageBrowser'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Think' => '269248588@qq.com' }
  s.source           = { :git => 'https://github.com/CoderThink/YDImageBrowser.git', :tag => s.version.to_s }
  s.default_subspec = 'YY'

  s.ios.deployment_target = '9.0'

  s.source_files = 'YDImageBrowser/Classes/**/*'
  
  s.subspec 'YY' do |yy|
    yy.dependency 'YYWebImage'
  end
end
