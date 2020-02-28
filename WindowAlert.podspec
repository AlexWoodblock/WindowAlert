#
# Be sure to run `pod lib lint WindowAlert.podspec' to ensure this is a
# valid spec before submitting.
#

Pod::Spec.new do |s|
  s.name             = "WindowAlert"
  s.version          = "2.1.0"
  s.summary          = "Helper class to simplify presentation of UIAlertController"

  s.description      = <<-DESC
WindowAlert is a class that helps you handle the presentation of UIAlertController. It creates separate UIWindow with transparent UIViewController, and presents it on top of that UIViewController, so you don't have to worry about looking for a view controller to present your UIAlertController on.
                       DESC

  s.homepage         = "https://github.com/DrBreen/WindowAlert"
  s.license          = 'Apache 2.0'
  s.author           = { "Alexander" => "wryyy906@gmail.com" }
  s.source           = { :git => "https://github.com/DrBreen/WindowAlert.git", :branch => 'master', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'WindowAlert/Classes/**/*'

  s.frameworks = 'UIKit'
end
