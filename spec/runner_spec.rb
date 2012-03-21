require 'spec/helper'

describe 'Urls::Runner' do
  def stdout
    super.chomp
  end

  def stderr
    super.chomp
  end

  before { FileUtils.rm_rf(ENV['URLS_HOME']) }

  describe 'default help' do
    it 'prints help with no arguments' do
      urls
      stdout.must_match /^Tasks/
    end

    it 'prints help with --help' do
      urls '--help'
      stdout.must_match /^Tasks/
    end
  end

  describe 'commands' do
    it 'adds a url' do
      urls 'add http://wtf.com'
      stdout.must_equal "urls: Added http://wtf.com"
    end

    it 'deletes a url' do
      urls 'add http://wtf.com'
      urls 'rm http://wtf.com'

      stdout.must_equal "urls: Deleted http://wtf.com"
    end

    it 'prints an error when deleting a nonexistant url' do
      urls 'rm blah'
      stderr.must_equal "urls: blah not found"
    end

    it 'lists a url' do
      urls 'add http://wtf.com'
      urls 'list'
      stdout.must_equal "http://wtf.com"
    end
  end
end
