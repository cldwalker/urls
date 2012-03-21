require 'spec/helper'

describe 'Urls::Runner' do
  def stdout
    super.chomp
  end

  def stderr
    super.chomp
  end

  before do
    FileUtils.rm_rf(ENV['URLS_HOME'])
    FileUtils.rm_rf(ENV['TAG_HOME'])
  end

  describe 'default help' do
    it 'prints help with no arguments' do
      urls
      stdout.must_match /^Usage: urls/
    end

    it 'prints help with --help' do
      urls '--help'
      stdout.must_match /^Usage: urls/
    end
  end

  describe 'commands' do
    it 'adds a url' do
      urls 'add http://wtf.com'
      stdout.must_equal "urls: Added http://wtf.com"
    end

    it 'adds a url with a tag' do
      urls 'add http://dodo.com -t bird'
      urls 'list bird'
      stdout.must_equal "http://dodo.com"
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

    it 'lists a url by a tag' do
      urls 'add http://dodo.com -t bird'
      urls 'list bird'
      stdout.must_equal "http://dodo.com"
    end
  end

  describe "$URLS_RC" do
    it 'loads when defined' do
      with_rc "puts 'RC in the house'" do
        urls
        stdout.must_match /RC in the house/
      end
    end
  end
end
