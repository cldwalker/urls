# -*- encoding: utf-8 -*-
require 'rubygems' unless defined? :Gem
require File.dirname(__FILE__) + "/lib/urls/version"

Gem::Specification.new do |s|
  s.name        = "urls"
  s.version     = Urls::VERSION
  s.authors     = ["Gabriel Horner"]
  s.email       = "gabriel.horner@gmail.com"
  s.homepage    = "http://github.com/cldwalker/urls"
  s.summary =  "urls - bookmarking from the commandline or web"
  s.description = "TODO"
  s.required_rubygems_version = ">= 1.3.6"
  s.executables = %w(urls)
  s.add_dependency 'boson', '~> 1.2'
  s.add_dependency 'dm-core'
  s.add_dependency 'dm-yaml-adapter'
  s.add_dependency 'dm-migrations'
  s.add_dependency 'dm-timestamps'
  s.add_dependency 'dm-validations'
  s.add_development_dependency 'minitest', '~> 2.11.0'
  s.add_development_dependency 'bahia', '~> 0.5'
  s.add_development_dependency 'rake', '~> 0.9.2'
  s.files = Dir.glob(%w[{lib,spec}/**/*.rb bin/* [A-Z]*.{txt,rdoc,md} ext/**/*.{rb,c} **/deps.rip]) + %w{Rakefile .gemspec .travis.yml}
  s.extra_rdoc_files = ["README.md", "LICENSE.txt"]
  s.license = 'MIT'
end
