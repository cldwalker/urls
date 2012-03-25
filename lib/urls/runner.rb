require 'urls'
require 'boson/runner'
require 'hirb'
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
      abort "urls: #{url} already exists" if Url.first(name: Url.urlify(url))

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
      if u = Url.first(name: Url.urlify(url))
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

    option :tab, type: :boolean, desc: 'print tab-delimited table'
    option :fields, type: :array, default: [:name, :desc], values: [:name, :desc],
      desc: 'Fields to display'
    option :simple, type: :boolean, desc: 'only lists urls'
    option :open, type: :boolean, desc: 'open in browser'
    option :copy, type: :boolean, desc: 'copy to clipboard'
    desc "list all urls or by a tag"
    def list(tag=nil, options={})
      if options.delete(:simple)
        options.update headers: false, fields: [:name], tab: true
      end

      query = {}
      query[:name] = Urls.tag('list', tag, capture: true).split("\n") if tag
      urls = Url.all query

      Hirb.enable
      if options[:open]
        choices = menu urls.map(&:name)
        cmds = Urls.browser.split(/\s+/)
        choices.each {|u| system(*cmds, u) }
      elsif options[:copy]
        choices = menu urls.map(&:name)
        Urls.copy choices
      else
        puts table(urls, options)
      end
    end

    private

    def menu(arr)
      Hirb::Menu.render(arr)
    end

    def table(rows, options={})
      Hirb::Helpers::AutoTable.render(rows, options)
    end

    def say(*args)
      puts *args.map {|e| "urls: #{e}" }
    end
  end
end
