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
    describe 'add' do
      it 'adds a url' do
        urls 'add http://wtf.com'
        stdout.must_equal "urls: Added http://wtf.com"
      end

      it 'adds a url with a tag' do
        urls 'add http://dodo.com -t bird'
        urls 'list bird'
        stdout.must_equal "http://dodo.com"
      end

      it 'prints error for double submission' do
        urls 'add http://wtf.com'
        urls 'add http://wtf.com'
        stderr.must_equal "urls: http://wtf.com already exists"
      end

      it 'prints error when validation fails' do
        urls 'add ""'
        stderr.must_equal "urls: Failed to save url - Name must not be blank"
      end
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

    it 'can define a custom adapter' do
      with_rc "Urls.adapter = 'sqlite'" do
        urls
        stderr.must_match /cannot load.*dm-sqlite-adapter/
      end
    end
  end
end
