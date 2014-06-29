# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'snoopit/version'

Gem::Specification.new do |spec|
  spec.name          = 'snoopit'
  spec.version       = Snoopit::VERSION
  spec.authors       = ['Robert Birch']
  spec.email         = ['robdbirch@gmail.com']
  spec.description   = %q{Snoops files for specified information via a simple configuration file}
  spec.summary       = %q{Simple tool for monitoring process log files for specified events and then generating basic notifications. This is an extensible and data driven solution. It provides a single location to manage log scraping duties.}
  spec.homepage      = 'https://github.com/robdbirch/snoopit/blob/master/README.md'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '> 3.0 ', '=>1.9.3'

  spec.add_runtime_dependency 'awesome_print', '~> 1.2'
  spec.add_runtime_dependency 'stomp', '~> 1.3'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake', '10.1'
  spec.add_development_dependency 'rspec', '2.14'
end
