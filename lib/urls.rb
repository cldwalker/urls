require 'urls/url'
require 'urls/version'

module Urls
  def self.home
    @home ||= (ENV['URLS_HOME'] || File.join(Dir.home, '.urls')).tap do |dir|
      FileUtils.mkdir_p(dir)
    end
  end

  # database for datamapper. Can be a uri string or a hash of options
  class << self; attr_accessor :db; end

  def self.setup
    self.db ||= { adapter: 'yaml', path: home }
    DataMapper.setup(:default, db)
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
