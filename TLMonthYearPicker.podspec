Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.name         = "TLMonthYearPicker"
  s.version      = "4.1.1"
  s.summary      = "A simple month and year picker."
  s.description  = "A simple month and year picker."
  s.homepage     = "https://github.com/lee5783/TLMonthYearPicker"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.license      = { :type => "MIT", :file => "LICENSE" }

  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.author             = "lee5783"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.platform     = :ios, "12.0"

  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source       = { :git => "https://github.com/lee5783/TLMonthYearPicker.git", :tag => "4.1.1" }
  # s.source       = { :path => '.' }

  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source_files  = "Classes", "Classes/**/*.{h,m,swift}"
  s.pod_target_xcconfig = { "SWIFT_VERSION" => "5.0" }
  s.swift_versions = '5.0'
end
