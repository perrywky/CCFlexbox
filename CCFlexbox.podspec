Pod::Spec.new do |s|
  s.name         = "CCFlexbox"
  s.version      = "0.0.1"
  s.summary      = "An iOS layout library like Flexbox."

  s.homepage     = "https://github.com/perrywky/CCFlexbox"
  s.screenshots  = "https://raw.githubusercontent.com/perrywky/CCFlexbox/master/demo.gif"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "Qi Peng" => "perrywky@gmail.com" }
  s.social_media_url   = "https://twitter.com/perrywky"

  s.platform     = :ios
  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/perrywky/CCFlexbox.git", :tag => "0.0.1" }

  s.source_files  = "Source/CCFlexbox.swift"

  s.requires_arc = true
end
