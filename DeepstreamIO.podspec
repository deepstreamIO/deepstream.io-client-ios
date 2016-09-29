Pod::Spec.new do |s|
  s.name                      = "DeepstreamIO"
  s.version                   = "0.8.0"
  s.summary                   = "The open realtime server - a fast, secure and scalable websocket & tcp server for mobile, web & iot"
  s.homepage                  = "https://deepstream.io"
  s.license                   = { :type => 'Apache 2.0', :file => 'LICENSE' }
  s.authors                   = { "Akram Hussein" => 'akramhussein@gmail.com', "Yasser Fadl" => 'yasser.fadl@deepstreamhub.com' }
  s.social_media_url          = "http://twitter.com/deepstreamio"

  s.source                    = { :http => "https://github.com/deepstreamIO/deepstream.io-client-ios/releases/download/0.8.0/DeepstreamIO.zip" }

  s.requires_arc              = true

  s.ios.deployment_target     = '8.3'

  s.public_header_files       = 'src/DeepstreamIO.h'
  s.source_files              = 'src/DeepstreamIO.h'
  s.preserve_paths            = '{j2objc,src}/**/*.{h,m,a}'
  s.libraries                 = 'jre_emul', 'z'
  s.ios.vendored_libraries    = 'lib/iosRelease/libdeepstream.io-client-java-j2objc.a'
  s.ios.xcconfig = {
    'LIBRARY_SEARCH_PATHS'  => '${PODS_ROOT}/DeepstreamIO/j2objc/lib'
  }
  s.xcconfig = {
    'HEADER_SEARCH_PATHS'   => '${PODS_ROOT}/DeepstreamIO/j2objc/include ${PODS_ROOT}/DeepstreamIO/src/main/objc'
  }
end

