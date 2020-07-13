#
# Be sure to run `pod lib lint SwiftyAnalytics.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SwiftyAnalytics'
  s.version          = '0.1.0'
  s.summary          = 'A short description of SwiftyAnalytics.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/markgravity/SwiftyAnalytics'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'markgravity' => 'markgravity.in@gmail.com' }
  s.source           = { :git => 'https://github.com/markgravity/SwiftyAnalytics.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.watchos.deployment_target = '4.0'
  s.ios.deployment_target = '13.0'
  s.swift_version = '5.0'
  s.source_files = 'SwiftyAnalytics/Classes/**/*'
  
  # s.resource_bundles = {
  #   'SwiftyAnalytics' => ['SwiftyAnalytics/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.static_framework = true
  s.subspec 'Core' do |sp|
    sp.source_files = 'SwiftyAnalytics/Classes/Core/**/*'
  end
 
  s.subspec 'Firebase' do |sp|
    sp.source_files = 'SwiftyAnalytics/Classes/Providers/Firebase/**/*'
    sp.dependency 'SwiftyAnalytics/Core'
    sp.dependency 'Firebase/Analytics'
  end
  
  s.subspec 'Facebook' do |sp|
    sp.source_files = 'SwiftyAnalytics/Classes/Providers/Facebook/**/*'
    sp.dependency 'SwiftyAnalytics/Core'
    sp.dependency 'FBSDKCoreKit'
  end
  
  s.subspec 'Tenjin' do |sp|
    sp.source_files = 'SwiftyAnalytics/Classes/Providers/Tenjin/**/*'
    sp.dependency 'SwiftyAnalytics/Core'
    sp.preserve_paths = 'SwiftyAnalytics/Classes/Providers/Tenjin/SDK/*.h'
    sp.vendored_libraries = 'SwiftyAnalytics/Classes/Providers/Tenjin/SDK/libTenjinSDKUniversal.a'
    sp.xcconfig = { 'HEADER_SEARCH_PATHS' => "${PODS_ROOT}/#{s.name}/Classes/Providers/Tenjin/**" }
  end
end
