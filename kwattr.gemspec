# coding: utf-8
require_relative 'lib/kwattr'

Gem::Specification.new do |spec|
  spec.name          = "kwattr"
  spec.version       = KWAttr::VERSION
  spec.authors       = ["Étienne Barrié"]
  spec.email         = ["etienne.barrie@gmail.com"]

  spec.summary       = %q{attr_reader + initialize with keyword arguments}
  spec.description   = %q{}
  spec.homepage      = "https://github.com/etiennebarrie/kwattr"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.2"
  spec.add_development_dependency "benchmark-ips", "~> 2.2"
end
