Pod::Spec.new do |s|
  s.name                = "TencentOpenApiSDK"
  s.version             = "2.9.0"
  s.summary             = "The Official iOS SDK of Tencent Open API."
  s.homepage            = "http://wiki.open.qq.com"
  s.license             = {
    :type => 'Copyright',
    :text => <<-LICENSE
      Copyright (c) 2014 Tencent. All rights reserved.
      LICENSE
  }
  s.author              = { "OpenQQ" => "opensupport@qq.com" }
  s.platform            = :ios
  s.requires_arc        = true

  s.source              = { :git=> "https://github.com/candyan/TencentOpenApiSDK.git", :tag => "#{s.version}" }
  s.xcconfig            = { "FRAMEWORK_SEARCH_PATHS" => "$(inherited)" }

  s.libraries      = 'iconv', 'z', 'c++', 'sqlite3'
  s.frameworks     = 'Security', 'SystemConfiguration', 'CoreGraphics', 'CoreTelephony'

  s.default_subspec = 'Basic'

  s.subspec "64bit" do |tc_64|
    tc_64.vendored_frameworks = '64Bit/TencentOpenAPI.framework'
    tc_64.source_files = '64Bit/TencentOpenAPI.framework/Headers/*.h'
    tc_64.resource_bundles    = {
      'TencentOpenAPI' => ['64Bit/TencentOpenApi_IOS_Bundle.bundle']
    }
  end

  s.subspec "32bit" do |tc_32|
    tc_32.vendored_frameworks = '32Bit/TencentOpenAPI.framework'
    tc_32.source_files = '32Bit/TencentOpenAPI.framework/Headers/*.h'
    tc_32.resource_bundles    = {
      'TencentOpenAPI' => ['32Bit/TencentOpenApi_IOS_Bundle.bundle']
    }
  end

  s.subspec "Basic" do |bs|
    bs.vendored_frameworks = 'Basic/TencentOpenAPI.framework'
    bs.source_files = 'Basic/TencentOpenAPI.framework/Headers/*.h'
  end

end
