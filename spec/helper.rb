gem 'minitest' unless ENV['NO_RUBYGEMS']
require 'minitest/autorun'
require 'urls'
require 'fileutils'
require 'bahia'

ENV['URLS_HOME'] = File.dirname(__FILE__) + '/.urls'
ENV['TAG_HOME'] = File.dirname(__FILE__) + '/.tag'

class MiniTest::Unit::TestCase
  include Bahia
end

MiniTest::Unit.after_tests do
  FileUtils.rm_rf(ENV['URLS_HOME'])
  FileUtils.rm_rf(ENV['TAG_HOME'])
end
