# coding: utf-8
$LOAD_PATH << File.expand_path('lib', __dir__)
require 'knife-bulk/version'

Gem::Specification.new do |spec|
  spec.name          = 'knife-bulk'
  spec.version       = Knife::Bulk::VERSION
  spec.authors       = ['Joshua Riojas']
  spec.license       = 'MIT'
  spec.homepage      = 'https://github.com/joshuariojas/knife-bulk'
  spec.summary       = %q{Plugin that adds functionality of running bulk requests against Chef Infra Server.}
  spec.description   = spec.summary

  spec.files         = %w{LICENSE} + Dir.glob('{lib,spec}/**/*')
  spec.require_paths = ['lib']
end
