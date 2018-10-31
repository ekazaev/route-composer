#
# Be sure to run `pod lib lint RouteComposer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RouteComposer'
  s.version          = '0.9.20'
  s.summary          = 'Protocol oriented library that helps to handle view controllers composition, routing and deeplinking tasks.'
  s.swift_version    = '4.2'

  s.description      = <<-DESC
    RouteComposer is the protocol oriented, Cocoa UI abstractions based library that helps to handle view controllers composition, routing
    and deep linking tasks in the IOS application.
                       DESC

  s.homepage         = 'https://github.com/saksdirect/route-composer'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Evgeny Kazaev' => 'eugene.kazaev@hbc.com' }
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
