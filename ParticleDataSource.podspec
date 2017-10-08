Pod::Spec.new do |spec|
  spec.name                  = 'ParticleDataSource'
  spec.version               = '1.0'
  spec.summary               = 'DataSource framework for Particle projects.'
  spec.description           = 'A framework used for modeling common UI <-> data structures on iOS.'
  spec.homepage              = 'https://github.com/ParticleApps/'
  spec.license               = { :type => 'MIT', :file => 'LICENSE' }
  spec.author                = { 'Rocco Del Priore' => 'rocco@particleapps.co' }
  spec.source                = { :git => 'https://github.com/ParticleApps/DataSource.git', :tag => spec.version.to_s }
  spec.social_media_url      = 'https://twitter.com/ParticleAppsCo'
  spec.ios.deployment_target = '9.0'
  spec.source_files          = 'ParticleDataSource/Classes/**/*'
  spec.dependency "ParticleCategories"
end
