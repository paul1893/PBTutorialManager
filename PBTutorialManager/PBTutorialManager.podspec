Pod::Spec.new do |s|

  s.name         = "PBTutorialManager"
  s.version      = "1.0.0"
  s.summary      = "An easy way to manipulate view targets to create tutorial in your app."
  s.description  = <<-DESC
  This library has been created to create a tutorial in-app for your app. It uses targets view and you can play with these.
                   DESC
  s.homepage     = "https://github.com/paul1893/PBTutorialManager"
  s.screenshots  = "https://raw.githubusercontent.com/paul1893/PBTutorialManager/master/Screenshots/demo.gif"
  s.author             = { "paul1893" => "pspol@hotmail.fr" }
  s.license      = '{ :type => "MIT", :file => "license" }'
  s.social_media_url   = "https://github.com/paul1893"
  s.ios.deployment_target = '8.0'

  s.source       = { :git => "https://github.com/paul1893/PBTutorialManager.git", :tag => s.version }
  s.ios.source_files  = "PBTutorialManager/**/*.{swift}"
  s.exclude_files = "PBTutorialManager/Example/**/*", "PBTutorialManager/AppDelegate.swift", "PBTutorialManager/Base.lproj/**/*"
  s.resource_bundle = { 'REIS-Regular' => 'PBTutorialManager/Ressources/*.otf' }

  s.frameworks  = "UIKit", "Foundation"
  s.dependency 'JMHoledView'

  s.requires_arc = true
  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }

end
