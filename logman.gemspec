# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'logman/version'

Gem::Specification.new do |spec|
  spec.name          = "logman"
  spec.version       = Logman::VERSION
  spec.authors       = ["Branko Krstic"]
  spec.email         = ["saicoder.net@gmail.com"]
  spec.description   = %q{Logman is Web Console/API for gathering logs from various sources and analyzing them. Logs are saved to mongo database.}
  spec.summary       = %q{Web Console/API for gathering logs from various sources and analyzing them}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "bson_ext"
  
  spec.add_runtime_dependency "sinatra", "~> 1.4.4"
  spec.add_runtime_dependency "sinatra-contrib", "~> 1.4.2"
  spec.add_runtime_dependency "mongoid", "~> 3.1.6"
  spec.add_runtime_dependency "bcrypt-ruby", '~> 3.1.2'

end
