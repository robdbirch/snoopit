# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'snoopit/version'

Gem::Specification.new do |spec|
  spec.name          = "snoopit"
  spec.version       = Snoopit::VERSION
  spec.authors       = ["Robert Birch"]
  spec.email         = ["robdbirch@gmail.com"]
  spec.description   = %q{Snoops files for specified information via a simple configuration file}
  spec.summary       = %q{Using regular expressions snoops files or directories for specific information. Sends events and tracks repeated invocations as not to send repeat events}
  spec.homepage      = "https://github.com/robdbirch/snoopit/blob/master/README.md"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
