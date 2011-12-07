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
    ENV['TAG_MODEL'] = 'urls'
  end

  def self.add_tag(url, tags)
    tag('add', url, '--tags', *tags)
  end

  def self.tag(*cmds)
    system('tag', *cmds)
  end
end
