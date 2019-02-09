# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_concurrency/version'

Gem::Specification.new do |spec|
  spec.name = 'active_concurrency'
  spec.version = ActiveConcurrency::VERSION
  spec.authors = ['Juan Gomez']
  spec.email = ['j.gomez@drexed.com']

  spec.summary = 'Gem for developing simple concurrency programs.'
  spec.description = 'Libray for build multi thread/process programs.'
  spec.homepage = 'http://drexed.github.io/active_concurrency'
  spec.license = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'fasterer'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'reek'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
end
