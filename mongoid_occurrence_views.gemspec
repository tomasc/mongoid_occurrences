lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mongoid_occurrence_views/version'

Gem::Specification.new do |spec|
  spec.name          = 'mongoid_occurrence_views'
  spec.version       = MongoidOccurrenceViews::VERSION
  spec.authors       = ['Tomas Celizna', 'Asger Behncke Jacobsen']
  spec.email         = ['tomas.celizna@gmail.com', 'a@asgerbehnckejacobsen.dk']

  spec.summary       = "Makes one's life easier when working with events that have multiple occurrences, or a recurring schedule."
  spec.homepage      = 'https://github.com/tomasc/mongoid_occurrence_views'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'ice_cube'
  spec.add_dependency 'mongoid', '>= 5.1', '< 8'
  spec.add_dependency 'mongoid_ice_cube_extension', '>= 0.1.1'

  spec.add_development_dependency 'activesupport', '> 3.0'
  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'database_cleaner'
  spec.add_development_dependency 'guard-minitest'
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'rake', '~> 10.0'
end
