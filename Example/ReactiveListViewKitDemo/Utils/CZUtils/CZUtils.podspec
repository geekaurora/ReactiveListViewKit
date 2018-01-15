#
# Be sure to run `pod lib lint CZUtils.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = 'CZUtils'
s.version          = '1.1.3'
s.summary          = 'Powerful toolset to enhance Utils layer'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

s.description      = <<-DESC
- CZMutexLock on top of GCD
- NSNullGuard
- MainQueueScheduler
- SwizzlingHelper
- ThreadSafeDictionary
- NibLoadable for UIView/Cell
DESC

s.homepage         = 'https://github.com/geekaurora/CZUtils'
# s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'geekaurora' => 'showt2me@gmail.com' }
s.source           = { :git => 'https://github.com/geekaurora/CZUtils.git', :tag => s.version.to_s }
# s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

s.ios.deployment_target = '9.0'

s.source_files = 'CZUtils/CZUtils/**/*'
s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3' }

# s.resource_bundles = {
#   'CZUtils' => ['CZUtils/Assets/*.png']
# }

# s.public_header_files = 'Pod/Classes/**/*.h'
# s.frameworks = 'UIKit', 'MapKit'

#s.dependency 'SDWebImage', '~> 2.3'

end


