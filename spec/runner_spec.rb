require 'spec/helper'

describe 'Urls::Runner' do
  def stdout
    super.chomp
  end

  def stderr
    super.chomp
  end

  def list_urls(arg=nil)
    urls "list #{arg} --simple"
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
        list_urls('bird')
        stdout.must_equal "http://dodo.com"
      end

      it 'prints error for redundant submission' do
        urls 'add http://wtf.com'
        urls 'add http://wtf.com'
        stderr.must_equal "urls: http://wtf.com already exists"
      end

      it 'prints error for redundant submission without http' do
        urls 'add http://wtf.com'
        urls 'add wtf.com'
        stderr.must_equal "urls: wtf.com already exists"
      end

      it 'prints error when validation fails' do
        urls 'add ""'
        stderr.must_equal "urls: Failed to save url - Name must not be blank"
      end

      it 'automatically prepends http:// if not given' do
        urls 'add google.com'
        list_urls
        stdout.must_equal "http://google.com"
      end
    end

    it 'deletes a url' do
      urls 'add http://wtf.com'
      urls 'rm http://wtf.com'

      stdout.must_equal "urls: Deleted http://wtf.com"
    end

    it 'deletes a url without specifying http' do
      urls 'add http://wtf.com'
      urls 'rm wtf.com'

      stdout.must_equal "urls: Deleted wtf.com"
    end

    it 'prints an error when deleting a nonexistant url' do
      urls 'rm blah'
      stderr.must_equal "urls: blah not found"
    end

    it 'lists a url' do
      urls 'add http://wtf.com some desc'
      urls 'list'
      stdout.must_equal <<-STR.chomp.gsub(/^\s*/, '')
        +----------------+-----------+
        | name           | desc      |
        +----------------+-----------+
        | http://wtf.com | some desc |
        +----------------+-----------+
        1 row in set
      STR
    end

    it 'lists a url by a tag' do
      urls 'add http://dodo.com -t bird'
      urls 'list bird'
      stdout.must_equal <<-STR.chomp.gsub(/^\s*/, '')
        +-----------------+------+
        | name            | desc |
        +-----------------+------+
        | http://dodo.com |      |
        +-----------------+------+
        1 row in set
      STR
    end

    it 'lists a url and opens it' do
      skip 'figure out how'
    end

    it 'edits a url' do
      ENV['EDITOR'] = 'echo'
      urls 'edit'
      stdout.must_equal Urls.home + '/urls.yml'
    end

    it 'edits a url' do
      ENV['EDITOR'] = 'echo'
      urls 'edit'
      stdout.must_equal Urls.home + '/urls.yml'
    end

    it "doesn't edit a url if a non-yaml db" do
      with_rc "Urls.db = {adapter: 'in_memory'}" do
        urls 'edit'
        stderr.must_equal 'urls: edit only works with yaml db'
      end
    end
  end

  describe "$URLS_RC" do
    it 'loads when defined' do
      with_rc "puts 'RC in the house'" do
        urls
        stdout.must_match /RC in the house/
      end
    end

    it 'can define a custom db' do
      with_rc "Urls.db = {adapter: 'sqlite'}" do
        urls
        stderr.must_match /cannot load.*dm-sqlite-adapter/
      end
    end
  end
end
