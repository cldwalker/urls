require 'urls'
require 'thor'

module Urls
  class Runner < Thor
    def self.start(*)
      Urls.setup
      super
    end

    desc "add URL *DESC -t *TAGS", "adds url with optional description and tags"
    def add(url, *desc)
      Url.create(name: url, desc: desc.join(' '))
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

    desc "list", "list urls"
    def list
      puts Url.all.map(&:name)
    end
  end
end
