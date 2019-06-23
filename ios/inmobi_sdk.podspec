#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'inmobi_sdk'
  s.version          = '0.0.5'
  s.summary          = 'Flutter plugin for InMobi advertising SDK.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'http://www.avinium.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Nick Fisher' => 'nick.fisher@avinium.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.ios.deployment_target = '8.0'
  s.static_framework = true
  s.dependency 'InMobiSDK'
end

