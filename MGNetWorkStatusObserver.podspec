

Pod::Spec.new do |s|
s.name = "MGNetWorkStatusObserver"
s.version = "1.0.0"
s.summary = "a tool to get current network status and observer network change"
s.description = "a tool to get current network status and observer network change"
s.homepage = "https://github.com/MR-THT/MGNetWorkStatusObserver"
s.license = { :type => "MIT", :file => "LICENSE" }
s.author = { "MR-THT" => "1096462733@qq.com" }
s.platform = :ios, "7.0"
s.source = { :git => "https://github.com/MR-THT/MGNetWorkStatusObserver.git", :tag => "#{s.version}" }
s.source_files = "MGNetWorkStatusObserver/**/*.{h,m}"
s.requires_arc = true
#s.dependency "Masonry", "~> 1.0.0"

end
