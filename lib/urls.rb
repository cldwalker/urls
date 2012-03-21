require 'urls/url'
require 'urls/version'

module Urls
  def self.home
    @home ||= (ENV['URLS_HOME'] || File.join(Dir.home, '.urls')).tap do |dir|
      FileUtils.mkdir_p(dir)
    end
  end

  # Adapter for datamapper. defaults to yaml
  class << self; attr_accessor :adapter; end

  def self.setup
    self.adapter ||= 'yaml'
    DataMapper.setup(:default, adapter: adapter, path: home)
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
