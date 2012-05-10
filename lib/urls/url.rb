require 'dm-core'
require 'dm-yaml-adapter'
require 'dm-migrations'
require 'dm-timestamps'
require 'dm-validations'

# set default string length
DataMapper::Property::String.length(255)

class Url
  include DataMapper::Resource

  property :id, Serial
  property :name, String, required: true
  property :desc, String
  property :created_at, DateTime
  property :updated_at, DateTime

  validates_uniqueness_of :name

  def self.urlify(url)
    url.include?('://') ? url : "http://#{url}"
  end

  def self.url_tags
    @url_tags ||= Urls.tagged_items
  end

  def self.reset_url_tags
    @url_tags = nil
  end

  def self.tagged_with(tag)
    Url.all name: Urls.tagged_with(tag)
  end

  def tags
    tag_list.join(", ")
  end

  def tag_list
    @tag_list ||= self.class.url_tags[name].to_s.split(/\s*,\s*/)
  end

  before :save do
    self.name = self.class.urlify(name)
  end
end
