# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hiki2latex/version'

Gem::Specification.new do |spec|
  spec.name          = "hiki2latex"
  spec.version       = Hiki2latex::VERSION
  spec.authors       = ["Shigeto R. Nishitani"]
  spec.email         = ["shigeto_nishitani@me.com"]

  spec.summary       = %q{convert hikidoc text to latex format.}
  spec.description   = <<-EOF
   hiki2latex is a format converter from hikidoc to latex, using hikidoc.
EOF
  spec.homepage      = 'https://github.com/daddygongon/hiki2latex'
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
#  if spec.respond_to?(:metadata)
#    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
#  else
#    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
#  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 1.8.6'

  spec.add_development_dependency "bundler", "~> 2.1"
  spec.add_development_dependency "rake", "~> 12.3.3"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "yard", "~> 0.9.11"
  spec.add_development_dependency "test-unit"
  spec.add_development_dependency "systemu"
  spec.add_development_dependency "hiki2md"
  spec.add_development_dependency "mathjax-yard"
  spec.add_development_dependency "hiki2latex"
  spec.add_development_dependency "colorize"

  spec.add_runtime_dependency "hikidoc","~>0.1.0"
end
