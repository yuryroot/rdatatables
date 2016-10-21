# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rdatatables/version'

Gem::Specification.new do |spec|
  spec.name          = 'rdatatables'
  spec.version       = RDataTables::VERSION
  spec.authors       = ['Yury Shchyhlinski']
  spec.email         = ['Shchyhlinski.YL@gmail.com']

  spec.summary       = 'Server-side processing of DataTables for Ruby. AR, Sequel and array are supported.'
  # spec.description   = ''
  spec.homepage      = 'https://github.com/yuryroot/rdatatables'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end



