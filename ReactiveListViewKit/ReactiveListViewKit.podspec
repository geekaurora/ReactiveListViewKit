Pod::Spec.new do |s|
s.name             = 'ReactiveListViewKit'
s.version          = '1.2.4'
s.summary          = 'MVVM + FLUX Reactive Facade ViewKit, eliminates Massive View Controller in unidirectional event/state flow manner.'

s.description      = <<-DESC
- MVVM + FLUX reactive facade ViewKit for feed based app development
- Eliminates Massive View Controller in unidirectional Event/State flow manner
DESC

s.homepage         = 'https://github.com/geekaurora/ReactiveListViewKit'
#s.screenshots     = ''
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'geekaurora' => 'showt2me@gmail.com' }
s.source           = { :git => 'https://github.com/geekaurora/ReactiveListViewKit.git', :tag => s.version.to_s }
# s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

s.ios.deployment_target = '10.0'
s.source_files = 'ReactiveListViewKit/ReactiveListViewKit/**/*'
s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3' }

# s.resource_bundles = {
#   'ReactiveListViewKit' => ['ReactiveListViewKit/Assets/*.png']
# }

# s.public_header_files = 'Pod/Classes/**/*.h'

s.frameworks = 'UIKit'
s.dependency 'CZUtils'

end


