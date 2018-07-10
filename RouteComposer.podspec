#
# Be sure to run `pod lib lint RouteComposer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RouteComposer'
  s.version          = '0.9.5'
  s.summary          = 'Standalone UIViewController\'s routing and composing library.'



  s.description      = <<-DESC
    RouteComposer is the library that helps handle routing and composition tasks in the IOs
    application and support deep linking written in Swift.
                       DESC

  s.homepage         = 'https://github.com/saksdirect/route-composer'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Evgeny Kazaev' => 'ekazaev@gilt.com' }
  s.source           = { :git => 'https://github.com/saksdirect/route-composer.git', :tag => s.version }

  s.ios.deployment_target = '9.0'

  s.source_files = 'RouteComposer/Classes/**/*'
  
  # s.resource_bundles = {
  #   'RouteComposer' => ['RouteComposer/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
