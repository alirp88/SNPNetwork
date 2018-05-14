Pod::Spec.new do |s|
    s.name             = 'SNPNetwork'
    s.version          = '0.1.2'
    s.summary          = 'SNPNetwork is a Swift-based HTTP networking library for iOS.'
    
    s.description      = <<-DESC
    SNPNetwork is a Swift-based HTTP networking library for iOS. It provides an interface on top of Alamofire
    that simplifies a number of common networking tasks. We've created it to add some features we needed in Snapp
    application which is not supported directly in Alamofire. Another key feature is a super-simplified JSON parsing
    facility that gives you clearer syntax by set it's 'responseKey' parameter.
    DESC
    
    s.homepage         = 'https://github.com/snapp-cab/SNPNetwork'
    s.license          = { :type => 'MIT', :file => 'SNPNetwork/LICENSE' }
    s.author           = { 'Arash Z.Jahangiri' => 'arashzjahangiri@gmail.com' }
    s.source           = { :git => 'https://github.com/snapp-cab/SNPNetwork.git', :tag => s.version.to_s }
    
    s.ios.deployment_target = '9.0'
    s.source_files = 'SNPNetwork/SNPNetwork/Classes'
    s.dependency 'Alamofire', '~> 4.0'
    s.dependency 'SNPUtilities'
end
