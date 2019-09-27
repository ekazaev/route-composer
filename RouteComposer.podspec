Pod::Spec.new do |s|
  s.name             = 'RouteComposer'
  s.version          = '2.3.1'
  s.summary          = 'Protocol oriented library that helps to handle view controllers composition, navigation and deep linking tasks.'
  s.swift_version    = '5.0'

  s.description      = <<-DESC
    RouteComposer is the protocol oriented, Cocoa UI abstractions based library that helps to handle view controllers composition, navigation
    and deep linking tasks in the iOS application. Can be used as the universal replacement for the Coordinator pattern.
                       DESC

  s.homepage         = 'https://github.com/saksdirect/route-composer'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Evgeny Kazaev' => 'eugene.kazaev@hbc.com' }
  s.source           = { :git => 'https://github.com/ekazaev/route-composer.git', :tag => s.version }

  s.ios.deployment_target = '9.0'
  s.source_files = 'RouteComposer/Classes/**/*'
  s.frameworks = 'UIKit'
end
