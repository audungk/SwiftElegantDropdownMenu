#
# Be sure to run `pod lib lint SwiftElegantDropdownMenu.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "SwiftElegantDropdownMenu"
  s.version          = "0.1.3"
  s.summary          = "An elegant dropdown menu for Swift, that's easy to use."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC
This component provides an easy, configurable dropdown menu with the ability to place it anywhere. It comes with a simple item selected callback and a variety of configurable options. This component is inspired by the **BTNavigationDropdownMenu** from **PhamBaTho**.
                       DESC

  s.homepage         = "https://github.com/arminlikic/SwiftElegantDropdownMenu"
  s.license          = 'MIT'
  s.author           = { "Armin Likic" => "armin-likic@live.com" }
  s.source           = { :git => "https://github.com/arminlikic/SwiftElegantDropdownMenu.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'SwiftElegantDropdownMenu' => ['Pod/Assets/*.png']
  }
end
