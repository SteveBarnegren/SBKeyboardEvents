#
# Be sure to run `pod lib lint SBKeyboardEvents.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SBKeyboardEvents'
  s.version          = '0.3'
  s.summary          = 'Easily respond to keyboard events'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Write less boilerplate code and easily respond to keyboard events
                       DESC

  s.homepage         = 'https://github.com/SteveBarnegren/SBKeyboardEvents'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Steve Barnegren' => 'steve.barnegren@gmail.com' }
  s.source           = { :git => 'https://github.com/SteveBarnegren/SBKeyboardEvents.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/SteveBarnegren'

  s.ios.deployment_target = '9.0'

  s.source_files = 'SBKeyboardEvents/SBKeyboardEvents/**/*.swift'
  s.swift_version = '5.0'

  s.frameworks = 'UIKit'
end
