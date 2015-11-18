Pod::Spec.new do |s|
  s.name         = "JCPullToSelect"
  s.version      = "1.0"
  s.summary      = "Stronger than pull-to-refresh"
  s.homepage     = "https://github.com/HJaycee/JCPullToSelect"
  s.license      = "MIT"
  s.author       = { "Hjaycee" => "hjaycee@163.com" }
  s.platform     = :ios, "6.0"
  s.source       = { :git => "https://github.com/HJaycee/JCPullToSelect.git", :tag => s.version }
  s.source_files  = "JCPullToSelect", "JCPullToSelect/**/*.{h,m}"
  s.resource  = "JCPullToSelect/JCPullToSelect.bundle"
  s.requires_arc = true
end
