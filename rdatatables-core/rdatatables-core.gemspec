
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rdatatables/version'

Gem::Specification.new do |spec|
  spec.name          = 'rdatatables-core'
  spec.version       = RDataTables::VERSION
  spec.authors       = ['Yury Shchyhlinski']
  spec.email         = ['Shchyhlinski.YL@gmail.com']

  spec.summary       = 'Ruby library for Server-side processing of DataTables (core)'
  spec.homepage      = "https://github.com/yuryroot/#{spec.name}"
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'builder', '~> 3.0'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'byebug'
end
