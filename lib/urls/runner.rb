require 'urls'
require 'thor'

module Urls
  class Runner < Thor
    def self.start(*)
      Urls.setup
      super
    end

    method_option :tags, type: 'array', desc: 'tags for url', aliases: '-t'
    desc "add URL *DESC -t *TAGS", "adds url with optional description and tags"
    def add(url, *desc)
      Url.create(name: url, desc: desc.join(' '))
      if options[:tags]
        Urls.add_tag(url, options[:tags])
      end
    end

    desc "rm URL", 'removes url'
    def rm(name)
      if url = Url.first(name: name)
        url.destroy
        puts "#{name} removed"
      else
        puts "#{name} not found"
      end
    end

    desc "list [TAG]", "list all urls or by a tag"
    def list(tag = nil)
      urls = tag ? `tag list #{tag}`.split("\n") : Url.all.map(&:name)
      puts urls
    end
  end
end
