class Recipe < ActiveRecord::Base

  belongs_to :user
  has_many :recipe_ingredients
  has_many :ingredients, through: :recipe_ingredients
  has_many :recipe_tags
  has_many :tags, through: :recipe_tags
  belongs_to :category

  extend Slugifiable::ClassMethods
  include Slugifiable::InstanceMethods
end
