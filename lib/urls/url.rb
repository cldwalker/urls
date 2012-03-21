require 'dm-core'
require 'dm-yaml-adapter'
require 'dm-migrations'
require 'dm-timestamps'
require 'dm-validations'

class Url
  include DataMapper::Resource

  property :id, Serial
  property :name, String, required: true
  property :desc, String
  property :created_at, DateTime
  property :updated_at, DateTime

  validates_uniqueness_of :name

  before :save do
    self.name = "http://#{name}" if !name.include?('://')
  end
end
