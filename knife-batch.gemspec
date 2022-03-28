# coding: utf-8
$LOADPATH << File.expand_path('lib', __dir__)
require 'knife-batch/version'

Gem::Specification.new do |spec|
  spec.name          = 'knife-batch'
  spec.version       = KnifeBatch::VERSION
  spec.authors       = ['Joshua Riojas']
  spec.license       = 'MIT'
  spec.homepage      = 'https://github.com/joshuariojas/knife-batch'
  spec.summary       = %q{Plugin that add functionality of running batch requests aginst Chef Infra Server.}
  spec.description   = spec.summary

  spec.files         = %w{LICENSE} + Dir.glob('{lib,spec}/**/*')
  spec.require_paths = ['lib']
end
