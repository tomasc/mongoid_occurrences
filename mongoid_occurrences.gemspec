lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mongoid_occurrences/version'

Gem::Specification.new do |spec|
  spec.name          = 'mongoid_occurrences'
  spec.version       = MongoidOccurrences::VERSION
  spec.authors       = ['Tomas Celizna', 'Asger Behncke Jacobsen']
  spec.email         = ['tomas.celizna@gmail.com', 'a@asgerbehnckejacobsen.dk']

  spec.summary       = 'Facilitates aggregations for events with multiple occurrences or a recurring schedule.'
  spec.homepage      = 'https://github.com/tomasc/mongoid_occurrences'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'ice_cube'
  spec.add_dependency 'mongoid', '>= 7.0.2', '< 9'
  spec.add_dependency 'mongoid-enum_attribute'
  spec.add_dependency 'mongoid_ice_cube_extension', '>= 0.1.1'

  spec.add_development_dependency 'activesupport', '> 3.0'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'database_cleaner-mongoid'
  spec.add_development_dependency 'factory_bot'
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-minitest'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'minitest-implicit-subject'
  spec.add_development_dependency 'rake'
end
