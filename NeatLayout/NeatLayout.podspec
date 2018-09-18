
Pod::Spec.new do |s|

  s.name             = 'NeatLayout'
  s.version          = '1.0.1'
  s.summary          = 'UIView extension for simple constraint-adding syntax.'
  s.description      = 'Provides methods for adding constraints in code with easy syntax similar to one of PureLayout.'

  s.homepage         = 'https://github.com/nitrey/NeatLayout'
  s.license          = { :type => 'MIT', :file => 'NeatLayout/LICENSE' }
  s.author           = { 'Antonov Alexander' => 'aa@finch-melrose.com' }
  s.source           = { :git => 'https://github.com/nitrey/NeatLayout.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  s.tvos.deployment_target = '9.0'
  
  s.source_files = 'NeatLayout/Source/**/*'

  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.2' }

end
