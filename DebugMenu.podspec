#
# Be sure to run `pod lib lint DebugMenu.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DebugMenu'
  s.version          = '1.0.15'
  s.summary          = 'DebugMenu helps you in testing app'

  s.description      = <<-DESC
  This is debug menu for test builds
                         DESC
                      
  s.homepage         = 'https://github.com/magenta-technology/DebugMenu'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Pavel Volkhin' => 'pavel.volhin@magenta-technology.com' }
  s.source           = { :git => 'https://github.com/magenta-technology/DebugMenu.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'

  s.source_files = 'DebugMenu/Classes/**/*.{swift}'
  s.resources = 'DebugMenu/Classes/**/*.{xib}'
  s.resource_bundles = {
    'DebugMenuBundle' => [
        'DebugMenu/Classes/**/*.{xib}'
    ]
  }
  
  s.dependency 'Fingertips', '~> 0.5.0'
  s.dependency 'netfox', '~> 1.17.0'
  s.swift_versions = ['4.2']
end
