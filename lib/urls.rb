require 'urls/url'
require 'urls/version'

module Urls
  def self.home
    @home ||= (ENV['URLS_HOME'] || File.join(Dir.home, '.urls')).tap do |dir|
      FileUtils.mkdir_p(dir)
    end
  end

  class << self
    # database for datamapper. Can be a uri string or a hash of options
    attr_accessor :db
    # command to open urls in browser
    attr_accessor :browser
  end

  self.browser = 'open'

  def self.setup
    self.db ||= { adapter: 'yaml', path: home }
    DataMapper.setup(:default, db)
    DataMapper.finalize
    DataMapper.auto_upgrade!
    ENV['TAG_MODEL'] = 'urls'
  end

  def self.add_tag(url, tags)
    Url.reset_url_tags
    tag('add', url, '--tags', *tags)
  end

  def self.tag(*cmds)
    options = cmds[-1].is_a?(Hash) ? cmds.pop : {}
    ENV['BOSONRC'] = '' # don't want urlsrc to pass as tagrc
    if options[:capture]
      `tag #{cmds.join(' ')}`
    else
      system('tag', *cmds)
    end
  end

  def self.tagged_with(tag)
    tag('list', tag, capture: true).split("\n")
  end

  def self.tagged_items
    tag('items', capture: true).split("\n").inject({}) do |h,line|
      url, tags = line.split("\t")
      h.update url => tags
    end
  end

  module API
    # copy url(s) to clipboard, default uses osx
    def copy(urls)
      system(%[echo "#{urls.join("\n")}" | pbcopy])
    end
  end
  extend API
end
