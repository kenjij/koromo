$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))
require 'koromo/version'


Gem::Specification.new do |s|
  s.name          = 'koromo'
  s.version       = Koromo::Version
  s.authors       = ['Ken J.']
  s.email         = ['kenjij@gmail.com']
  s.summary       = %q{MS SQL Server RESTful access proxy}
  s.description   = %q{A proxy server for MS SQL Server to present as a RESTful service.}
  s.homepage      = 'https://github.com/kenjij/koromo'
  s.license       = 'MIT'

  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_runtime_dependency 'kajiki', '~> 1.1'
  s.add_runtime_dependency 'thin', '~> 1.6'
  s.add_runtime_dependency 'sinatra', '~> 1.4'
  s.add_runtime_dependency 'tiny_tds', '~> 1.0'
  s.add_runtime_dependency 'sequel', '~> 4.0'
end
