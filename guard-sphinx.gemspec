# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'guard/sphinx/version'

Gem::Specification.new do |spec|
  spec.name          = "guard-sphinx"
  spec.version       = Guard::Sphinx::VERSION
  spec.authors       = ["John Schult"]
  spec.email         = ["schult@telmate.com"]
  spec.description   = "Manages Sphinx server"
  spec.summary       = "Manages Sphinx server"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
