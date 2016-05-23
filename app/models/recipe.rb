class Recipe < ActiveRecord::Base

  belongs_to :user
  has_many :recipe_ingredients
  has_many :ingredients, through: :recipe_ingredients
  has_many :recipe_tags
  has_many :tags, through: :recipe_tags
  belongs_to :category
  acts_as_votable

  require 'carrierwave/orm/activerecord'
  mount_uploader :avatar, MyUploader

  extend Slugifiable::ClassMethods
  include Slugifiable::InstanceMethods

  def self.search(search)
    where("name like ?", "%#{search}%")
  end
end
