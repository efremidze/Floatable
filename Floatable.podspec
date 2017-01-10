Pod::Spec.new do |s|
    s.name             = "Floatable"
    s.version          = "1.0.0"
    s.license          = 'MIT'
    s.homepage         = "https://github.com/efremidze/Floatable"
    s.author           = { "Lasha Efremidze" => "efremidzel@hotmail.com" }
    s.summary          = "Floating Animation Protocol (inspired by Periscope)"
    s.source           = { :git => 'https://github.com/efremidze/Floatable.git', :tag => s.version }
    s.source_files     = "Sources/*.swift"
    s.requires_arc     = true
    s.ios.deployment_target  = '8.0'
    s.ios.frameworks         = 'UIKit', 'Foundation'
end
