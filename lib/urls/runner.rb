require 'urls'
require 'boson/runner'
ENV['BOSONRC'] = ENV['URLS_RC'] || '~/.urlsrc'

module Urls
  class Runner < Boson::Runner
    # hook into init since it's after loading rc but before command execution
    def self.init(*)
      Urls.setup
      super
    end

    option :tags, type: :array, desc: 'tags for url'
    desc "adds url with optional description and tags"
    def add(url, *desc)
      options = desc[-1].is_a?(Hash) ? desc.pop : {}
      abort "urls: #{url} already exists" if Url.first(name: url)

      if (obj = Url.create(name: url, desc: desc.join(' '))).saved?
        if options[:tags]
          Urls.add_tag(url, options[:tags])
        end
        say "Added #{url}"
      else
        abort "urls: Failed to save url - #{obj.errors.full_messages.join(', ')}"
      end
    end

    desc 'removes url'
    def rm(url)
      if u = Url.first(name: url)
        u.destroy
        say "Deleted #{url}"
      else
        abort "urls: #{url} not found"
      end
    end

    desc 'edits urls in a file'
    def edit
      unless DataMapper::Repository.adapters[:default].options['adapter'] == 'yaml'
        abort 'urls: edit only works with yaml db'
      end
      file = Urls.home + '/urls.yml'
      system(ENV['EDITOR'] || 'vim', file)
    end

    desc "list all urls or by a tag"
    def list(tag = nil)
      urls = tag ? Urls.tag('list', tag, capture: true).split("\n") :
        Url.all.map(&:name)
      puts urls
    end

    private

    def say(*args)
      puts *args.map {|e| "urls: #{e}" }
    end
  end
end
