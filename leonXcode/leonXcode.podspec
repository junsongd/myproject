Pod::Spec.new do |s|
  s.name                  = 'leonXcode'
  s.version               = '1.0.0'
  s.summary               = 'A clone of the UIImagePickerController using the Assets Library Framework allowing for multiple asset selection'
  s.homepage              = ''
  s.license               = { :type => 'MIT', :file => 'README.md' }
  s.author                = { '' }
  s.source                = {''}
  s.platform              = :ios, '5.0'
  s.source_files          = 'leonXcode/*.{h,m}'
  s.resources             = 'leonXcode/*.Bundle'
  s.frameworks   = ['AssetsLibrary']
  s.requires_arc          = true
end
