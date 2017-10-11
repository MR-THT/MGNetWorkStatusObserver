
Pod::Spec.new do |s|
  s.name         = "MGNetWorkStatusObserver"
  s.version      = "0.2.0"
  s.summary      = "A short description of MGNetWorkStatusObserver."
  s.description  = <<-DESC
A short description of MGNetWorkStatusObserver.
                   DESC

  s.homepage     = "https://github.com/MR-THT/MGNetWorkStatusObserver.git"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "MR-THT" => "1096462733@qq.com" }
  s.ios.deployment_target = "7.0"

  s.source       = { :git => "https://github.com/MR-THT/MGNetWorkStatusObserver.git", :tag => "#{s.version}" }
  s.source_files  = "Classes", "Classes/**/*.{h,m}"

  # s.public_header_files = "Classes/**/*.h"

end
