gem 'minitest' unless ENV['NO_RUBYGEMS']
require 'minitest/autorun'
require 'urls'
require 'fileutils'
require 'bahia'

ENV['URLS_HOME'] = File.dirname(__FILE__) + '/.urls'
ENV['URLS_RC'] = File.dirname(__FILE__) + '/.urlsrc'
ENV['TAG_HOME'] = File.dirname(__FILE__) + '/.tag'

module TestHelpers
  # rc file for executables
  def with_rc(body)
    old = ENV['URLS_RC']
    ENV['URLS_RC'] = File.dirname(__FILE__) + '/.urlsrc.temp'
    File.open(ENV['URLS_RC'], 'w') {|f| f.write body }

    yield

    FileUtils.rm_f ENV['URLS_RC']
    ENV['URLS_RC'] = old
  end
end

class MiniTest::Unit::TestCase
  include Bahia
  include TestHelpers
end

MiniTest::Unit.after_tests do
  FileUtils.rm_rf(ENV['URLS_HOME'])
  FileUtils.rm_rf(ENV['TAG_HOME'])
  FileUtils.rm_f(ENV['URLS_RC'])
end
