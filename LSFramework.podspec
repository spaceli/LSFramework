Pod::Spec.new do |s|
  s.name         = "LSFramework"
  s.version      = "1.0.2"
  s.summary      = "李帅的工具"
  s.homepage     = "https://github.com/spaceli/LSFramework"
  s.license      = "MIT "
  # s.license    = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "李帅" => "spaceli@me.com" }
  s.source       = { :git => "https://github.com/spaceli/LSFramework.git", :tag => s.version }
  s.requires_arc = true
  s.source_files  = "LSFramework/**/*.{h,m}"

  s.subspec 'Categorys' do |ss|
    ss.source_files = 'LSFramework/Categorys/*.{h,m}'
  end
  
  s.subspec 'More' do |ss|
    ss.source_files = 'LSFramework/More/*.{h,m}'
  end

  s.subspec 'Utils' do |ss|
    ss.source_files = 'LSFramework/Utils/*.{h,m}'
  end


end
