#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
    s.name             = 'flutter_dropzone_web'
    s.version          = '1.0.0'
    s.summary          = 'No-op implementation of flutter_dropzone_web web plugin to avoid build issues on iOS'
    s.homepage         = 'https://github.com/deakjahn/flutter_dropzone_web'
    s.license          = { :file => '../LICENSE' }
    s.author           = { 'Gábor DEÁK JAHN' => 'deakjahn@gmail.com' }
    s.source           = { :path => '.' }
    s.source_files = 'Classes/**/*'
    s.public_header_files = 'Classes/**/*.h'
    s.dependency 'Flutter'

    s.ios.deployment_target = '8.0'
  end
