gem 'minitest' unless ENV['NO_RUBYGEMS']
require 'minitest/autorun'
require 'urls'
require 'fileutils'
require 'bahia'

ENV['URLS_HOME'] = File.dirname(__FILE__) + '/.urls'

class MiniTest::Unit::TestCase
  include Bahia
end

MiniTest::Unit.after_tests { FileUtils.rm_rf(ENV['URLS_HOME']) }
