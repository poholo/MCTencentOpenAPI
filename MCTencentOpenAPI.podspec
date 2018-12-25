Pod::Spec.new do |s|
    s.name             = "MCTencentOpenAPI"
    s.version          = "3.3.3.1"
    s.summary          = "TencentOpenAPI映射"
    s.description      = "MCTencentOpenAPI是对TencentOpenAPI的映射，使用pod依赖管理，便于开发者快速集成TencentOpenAPI的QQ登录、分享等功能。"
    s.license          = 'MIT'
    s.author           = { "littleplayer" => "mailjiancheng@163.com" }
    s.homepage         = "https://github.com/poholo/MCTencentOpenAPI"
    s.source           = { :git => "https://github.com/poholo/MCTencentOpenAPI.git", :tag => s.version.to_s }

    s.platform     = :ios, '8.0'
    s.requires_arc = true

    s.vendored_frameworks = 'SDK/TencentOpenAPI.framework'

    s.xcconfig = {
        'VALID_ARCHS' => 'arm64 x86_64',
    }
    s.pod_target_xcconfig = {
        'VALID_ARCHS' => 'arm64 x86_64'
    }

    s.ios.frameworks = 'CoreTelephony', 'SystemConfiguration'
    s.ios.libraries = 'z', 'sqlite3.0', 'c++', 'iconv'
    
end