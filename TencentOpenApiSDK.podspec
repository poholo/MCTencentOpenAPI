Pod::Spec.new do |s|
  s.name                = "TencentOpenApiSDK"
  s.version             = "2.3.1"
  s.summary             = "The Official iOS SDK of Tencent Open API."
  s.homepage            = "http://wiki.open.qq.com"
  s.license             = {
    :type => 'Copyright',
    :text => <<-LICENSE
      Copyright (c) 2014 Tencent. All rights reserved.
      LICENSE
  }
  s.author              = { "OpenQQ" => "opensupport@qq.com" }
  s.source              = { :git=> "https://github.com/candyan/TencentOpenApiSDK.git", :tag => "#{s.version}" }
  s.platform            = :ios

  s.vendored_frameworks = 'TencentOpenAPI.framework'
  s.resource_bundles    = {
        'TencentOpenAPI' => ['TencentOpenApi_IOS_Bundle.bundle']
  }
  s.requires_arc = true

end
