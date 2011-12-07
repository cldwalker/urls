require 'urls/url'

module Urls
  def self.home
    @home ||= (ENV['URLS_HOME'] || File.join(Dir.home, '.urls')).tap do |dir|
      FileUtils.mkdir_p(dir)
    end
  end

  def self.setup
    DataMapper.setup(:default, adapter: 'yaml', path: home)
    DataMapper.finalize
    DataMapper.auto_upgrade!
  end

  def self.tag(url, tags)
    system({'TAG_MODEL' => 'urls'}, 'tag', 'add', url, '--tags', *tags)
  end
end
