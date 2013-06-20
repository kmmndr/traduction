# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'traduction/version'

Gem::Specification.new do |spec|
  spec.name          = "traduction"
  spec.version       = Traduction::VERSION
  spec.authors       = ["Thomas Kienlen"]
  spec.email         = ["thomas.kienlen@lafourmi-immo.com"]
  spec.description   = %q{Simple tool to ease synchronization of locale files}
  spec.summary       = %q{Help maintaining Rails translation files}
  spec.homepage      = ""
  spec.license       = "AGPL"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.2"
  spec.add_development_dependency "rake"
  spec.add_dependency "rake"
  spec.add_dependency "git"
  spec.add_dependency "fastercsv"
  spec.add_dependency "activesupport"
end
